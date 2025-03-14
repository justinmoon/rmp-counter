package com.example.counter

import android.content.Context
import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import uniffi.counter.Action
import uniffi.counter.ModelUpdate
import uniffi.counter.RmpModel
import uniffi.counter.RmpViewModel

class ViewModel(context: Context) : ViewModel(), RmpViewModel  {
    private val model: RmpModel

    private var _count: MutableStateFlow<Int>
    val count: StateFlow<Int> get() = _count

    init {
        val dataDir = context.filesDir.absolutePath
        model = RmpModel(dataDir)
        model.listenForModelUpdates(this)
        _count = MutableStateFlow(model.getCount())
    }

    override fun modelUpdate(modelUpdate: ModelUpdate) {
        when (modelUpdate) {
            is ModelUpdate.CountChanged -> {
                _count.value = modelUpdate.count
            }
        }
    }

    fun action(action: Action) {
        model.action(action)
    }
}