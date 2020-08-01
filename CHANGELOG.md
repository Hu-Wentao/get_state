## [3.7.0] - 2020/8/1
* add: BaseViewModel and example "base_vm/main1.dart", to support multi model(get_arch_core.LiveData/LiveModel)
* feat(base_view_model.dart): add vmNotify();
* remove(view_model.dart): vmRefresh();
* refactor(view.dart): add registerVmInstance instead registerVM;
* feat(get_state.dart): export get_it;
* remove: All dependencies on "get_arch_core" were removed
## [3.6.0] - 2020/7/16
* refactor(ViewModel): VM constructor support async init model. see: "ViewModel.vmCreate()"doc
* remove(ViewModel): ViewModel.onInitState()
* feat: support "get_arch_core" ">=0.6.1 <2.0.0"

## [3.5.1] - 2020/7/5
* fix(ViewModel): Calling the "View.registerVM" multiple times will not repeat the registration; see: main4x1.dart

## [3.5.0] - 2020/7/4
* remove : freezed_annotation package
* feat(ViewModel): ViewModel.vmUpdate()add"bool forceUpdate"param

## [3.4.0] - 2020/6/24
* feat: View level VM register, see: main4x1.dart
* remove: VM async init.
* feat: use freezed for Model, see: main5.dart

## [3.3.0] - 2020/5/31
* fix: vmUpdate logic bug
* feat: View can init Model in onInitState() with vmInitModel()
    see: main7.dart
* add: check mounted before setState()
* add: new example "main7.dart"

## [3.2.1] - 2020/5/25
* feat: add onInitState() and onDispose() to ViewModel, To help you use some Controller

## [3.2.0+1] - 2020/5/25
* fix: v3.2.0 is dev version, don't use.

## [3.2.0] - 2020/5/14
* feat: add mixin"Recorder" for ViewModel, Allows toggling between historical states
* refactor: rename "ViewModel.model" to "ViewModel.m"

## [3.1.0] - 2020/5/3

* feat: Asynchronous initialization ViewMode
* add(main5.dart): Corresponding examples

## [3.0.0] - 2020/5/3

* rename from ca_presentation package
* add: example
