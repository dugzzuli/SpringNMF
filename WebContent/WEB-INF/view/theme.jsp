<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
    layui.link(winui.path + 'css/theme.css');
</script>

<div class="winui-tab" style="height:100%">
    <div class="winui-tab-left">
        <div class="winui-tab-title">主题</div>
        <div class="winui-scroll-y" style="height:auto;position:absolute;top:50px;bottom:0;">
            <ul class="winui-tab-nav">
                <li class="winui-this"><i class="fa fa-picture-o fa-fw"></i>背景</li>
                <li><i class="fa fa-paw fa-fw"></i>颜色</li>
                <li><i class="fa fa-lock fa-fw"></i>锁屏界面</li>
                <li><i class="fa fa-windows fa-fw"></i>开始</li>
                <li><i class="fa fa-tasks fa-fw"></i>任务栏</li>
            </ul>
        </div>
    </div>
    <div class="winui-tab-right">
        <div class="winui-scroll-y">
            <div class="winui-tab-content">
                <!-- 背景设置 -->
                <div class="winui-tab-item layui-show">
                    <h1>预览</h1>
                    <div class="background-preview">
                        <div class="preview-start">
                            <ul class="preview-menu">
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                            </ul>
                            <div class="preview-tilebox">
                                <div style="width:59px;height:59px;margin-right:1px;margin-bottom:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:59px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>
                            </div>
                            <div class="preview-tilebox preview-tilebox-lg">
                                <div style="width:59px;height:59px;margin-right:1px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:29px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:14px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;"></div>
                            </div>
                        </div>
                        <div class="preview-window">
                            <div class="preview-window-title"><p></p></div>
                            <span>示例文本</span>
                        </div>
                        <div class="preview-taskbar"></div>
                    </div>
                    <h2>选择图片</h2>
                    <div class="background-choose">
                        <img src="images/bg_01.jpg" />
                        <img src="images/bg_02.jpg" />
                        <img src="images/bg_03.jpg" />
                        <img src="images/bg_04.jpg" />
                        <img src="images/bg_05.jpg" />
                    </div>
                    <!-- 上传图片 -->
                    <input type="file" name="file" class="layui-upload-file" style="display:none;">
                    <div class="background-upload">
                        浏览
                    </div>
                    <div style="color:#ff6a00;margin-top:50px;">Tips：主题的相关设置存储于本地，下次打开可直接使用</div>
                </div>
                <!-- 颜色设置 -->
                <div class="winui-tab-item">
                    <h1>预览</h1>
                    <div class="background-preview">
                        <div class="preview-start">
                            <ul class="preview-menu">
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                            </ul>
                            <div class="preview-tilebox">
                                <div style="width:59px;height:59px;margin-right:1px;margin-bottom:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:59px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>
                            </div>
                            <div class="preview-tilebox preview-tilebox-lg">
                                <div style="width:59px;height:59px;margin-right:1px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:29px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:14px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;"></div>
                            </div>
                        </div>
                        <div class="preview-window">
                            <div class="preview-window-title"><p></p></div>
                            <span>示例文本</span>
                        </div>
                        <div class="preview-taskbar"></div>
                    </div>
                    <h2>主题色</h2>
                    <div class="color-choose">
                        <div class="theme-color-11"></div>
                        <div class="theme-color-12"></div>
                        <div class="theme-color-13"></div>
                        <div class="theme-color-14"></div>
                        <div class="theme-color-15"></div>
                        <div class="theme-color-16"></div>
                        <div class="theme-color-17"></div>
                        <div class="theme-color-18"></div>
                        <div class="theme-color-21"></div>
                        <div class="theme-color-22"></div>
                        <div class="theme-color-23"></div>
                        <div class="theme-color-24"></div>
                        <div class="theme-color-25"></div>
                        <div class="theme-color-26"></div>
                        <div class="theme-color-27"></div>
                        <div class="theme-color-28"></div>
                        <div class="theme-color-31"></div>
                        <div class="theme-color-32"></div>
                        <div class="theme-color-33"></div>
                        <div class="theme-color-34"></div>
                        <div class="theme-color-35"></div>
                        <div class="theme-color-36"></div>
                        <div class="theme-color-37"></div>
                        <div class="theme-color-38"></div>
                        <div class="theme-color-41"></div>
                        <div class="theme-color-42"></div>
                        <div class="theme-color-43"></div>
                        <div class="theme-color-44"></div>
                        <div class="theme-color-45"></div>
                        <div class="theme-color-46"></div>
                        <div class="theme-color-47"></div>
                        <div class="theme-color-48"></div>
                        <div class="theme-color-51"></div>
                        <div class="theme-color-52"></div>
                        <div class="theme-color-53"></div>
                        <div class="theme-color-54"></div>
                        <div class="theme-color-55"></div>
                        <div class="theme-color-56"></div>
                        <div class="theme-color-57"></div>
                        <div class="theme-color-58"></div>
                    </div>
                    <h2>显示"开始"菜单、任务栏和操作中心颜色（未实现）</h2>
                    <div class="layui-form winui-switch">
                        <input type="checkbox" lay-filter="toggleTransparent" lay-skin="switch" checked><span style="margin-left:15px; vertical-align:middle">开</span>
                    </div>
                    <h2>显示标题栏颜色（未实现）</h2>
                    <div class="layui-form winui-switch">
                        <input type="checkbox" lay-filter="toggleTransparent" lay-skin="switch" checked><span style="margin-left:15px; vertical-align:middle">开</span>
                    </div>
                    <div style="color:#ff6a00;margin-top:20px;">Tips：5排8列主题色尽情享用</div>
                </div>
                <!-- 锁屏界面 -->
                <div class="winui-tab-item">
                    <h1>预览</h1>
                    <div class="lockscreen-preview">
                        <div class="lockscreen-preview-time"></div>
                    </div>
                    <h2>选择图片</h2>
                    <div class="lockscreen-choose">
                        <img src="images/bg_01.jpg" />
                        <img src="images/bg_02.jpg" />
                        <img src="images/bg_03.jpg" />
                        <img src="images/bg_04.jpg" />
                        <img src="images/bg_05.jpg" />
                    </div>
                    <!-- 上传图片 -->
                    <input type="file" name="file" class="layui-upload-file" style="display:none;">
                    <div class="lockscreen-upload">
                        浏览
                    </div>
                    <div style="color:#ff6a00;margin-top:20px;">Tips：锁屏功能暂未实现</div>
                </div>
                <!-- 开始 -->
                <div class="winui-tab-item">
                    <h1>预览</h1>
                    <div class="background-preview">
                        <div class="preview-start">
                            <ul class="preview-menu">
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                                <li><div class="preview-menu-icon"></div><div class="preview-menu-text"></div></li>
                            </ul>
                            <div class="preview-tilebox">
                                <div style="width:59px;height:59px;margin-right:1px;margin-bottom:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:59px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>
                            </div>
                            <div class="preview-tilebox preview-tilebox-lg">
                                <div style="width:59px;height:59px;margin-right:1px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:59px;height:29px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:29px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:14px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:14px;height:14px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>
                                <div style="width:29px;height:29px;margin-bottom:1px;margin-right:1px;"></div>

                                <div style="width:59px;height:29px;margin-bottom:1px;"></div>
                            </div>
                        </div>
                        <div class="preview-window">
                            <div class="preview-window-title"><p></p></div>
                            <span>示例文本</span>
                        </div>
                        <div class="preview-taskbar"></div>
                    </div>
                    <h2>使用全屏幕"开始"菜单（未实现）</h2>
                    <div class="layui-form winui-switch">
                        <input type="checkbox" lay-filter="toggle" lay-skin="switch"><span style="margin-left:15px; vertical-align:middle">关</span>
                    </div>
                    <h2>开始菜单尺寸</h2>
                    <div class="layui-form winui-radio start-size">
                        <input type="radio" name="startsize" value="xs" title="迷你" lay-filter="startSize">
                        <input type="radio" name="startsize" value="sm" title="中等" lay-filter="startSize">
                        <input type="radio" name="startsize" value="lg" title="宽敞" lay-filter="startSize">
                    </div>
                    <div style="color:#ff6a00;margin-top:20px;">Tips：迷你不显示磁贴，中等显示一列磁贴，宽敞显示两列磁贴</div>
                </div>
                <!-- 任务栏 -->
                <div class="winui-tab-item">
                    <h1>任务栏</h1>
                    <h2 style="margin-top:0;">自动隐藏任务栏（未实现）</h2>
                    <div class="layui-form winui-switch">
                        <input type="checkbox" lay-filter="toggleTaskbar" lay-skin="switch"><span style="margin-left:15px; vertical-align:middle">关</span>
                    </div>
                    <h2>任务栏在屏幕上的位置</h2>
                    <div class="layui-form winui-radio taskbar-position">
                        <input type="radio" name="position" value="top" title="顶部" lay-filter="taskPosition">
                        <input type="radio" name="position" value="bottom" title="底部" lay-filter="taskPosition">
                        <input type="radio" name="position" value="left" title="靠左" lay-filter="taskPosition">
                        <input type="radio" name="position" value="right" title="靠右" lay-filter="taskPosition">
                    </div>
                    <div style="color:#ff6a00;margin-top:20px;">Tips：任务栏靠左靠右暂未实现,隐藏任务栏暂未实现</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="lib/winui/js/theme.js"></script>

