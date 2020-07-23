// Created by Hu Wentao.
// Email : hu.wentao@outlook.com
// Date  : 2020/5/24
// Time  : 19:35

///
/// 示例6:
///  使用 [Recorder], 使用injectable, 多View, 自定义Model
///
/// # [BaseViewModel] 暂不支持 [Recorder]
///
/// [BaseViewModel]不再使用内置的[_m]持有Model, 而是由开发者在VM自定义model字段
/// 这里推荐使用 [LiveData<T>]/[LiveModel<T>] 作为Model的类型, 适用于较大的项目
///
