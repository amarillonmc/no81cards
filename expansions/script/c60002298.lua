if not pcall(function() require("expansions/script/c60002290") end) then require("script/c60002290") end
local cm,m=lanp.U("设置卡","黄昏+黄昏教廷","黄昏教廷神子·辛勒斯")
dusk[m]={}
function cm.initial_effect(c)
	local e1=lane.I(c,c,{m,0},"TH,,,E,O",cm.con,"",cm.tg,cm.op)
	------------------------
	aux.EnablePendulumAttribute(c)
	local e2=dusk.Pe(c,c)
	local e3=lane.I(c,c,{m,1},"DES+DR,,,P",m,",",cm.tg1,cm.op2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return lanc.Filter(c,"IsLoc+IsFaceup","E") and lang.Get(tp,"E"):GetCount()>=15 and lang.GetFilter(tp,"N","IsName+IsFaceup","黄昏教廷神子·哈儿森",1 )
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return lanc.Filter(c,"AbleTo","H") end
	lanp.U("连锁信息",0,"TH",c,1,tp,"E")
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if lanp.U("效果处理",Duel.SendtoHand,c,{nil,"EFF"})>0 and Duel.GetFlagEffect(tp,m)==0 then
		local e1=lane.FC(e,tp,"",EVENT_PREDRAW,",,",cm.con1,cm.op1,{RESET_PHASE+PHASE_END,3})
		local e2=lane.F(e,tp,"",EFFECT_CANNOT_BE_EFFECT_TARGET,"SR,,N+0,1,,",aux.TargetBoolFunction(lanc.IsName,"黄昏教廷神子·哈尔森"),"",{RESET_PHASE+PHASE_END,3})
		table.insert(dusk.begin,e1)
		table.insert(dusk[m],c)
		table.insert(dusk[m],e1)
		table.insert(dusk[m],e2)
		lanp.U("标识",tp,m,RESET_PHASE+PHASE_END,0,3)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=dusk[m][1]
	if lang.GetFilter(tp,"E","IsTyp+AbleTo+IsFaceup","PE,H",1) then
		lanp.U("提示","S",tp,"ATH")
		local g=lang.SelectFilter(tp,"E","IsTyp+AbleTo+IsFaceup","PE,H")
		if #g>0 then
			if lanp.U("效果处理",Duel.SendtoHand,g,{nil,"EFF"})>0 and lanc.Filter(c,"IsLoc+CanSp",{"G/R",{e,0,tp}}) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(c,e,0,tp,false,false,POS_FACEUP)
			end
		end
	end
	for i=1,#dusk[m] do
		if aux.GetValueType(dusk[m][i])=="Effect" then 
			dusk[m][i]:Reset() 
			dusk[m][i]=0
		end
	end
	for i=1,#dusk[m] do
		table.remove(dusk[m])
	end
	Duel.ResetFlagEffect(tp,m)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return lanc.Filter("IsLoc+IsControler",{"M",tp}) end
	if chk==0 then return lang.GetFilter(tp,{"0","S"},"TgChk",e,1) end
	lanp.U("提示","S",tp,"DES")
	local g=lang.SelectTg(tp,{0,"S"},"TgChk",e)
	g:AddCard(c)
	lanp.U("连锁信息",0,"DES",g,2,0,"M+P")
end
function cm.op2(e,tp,eg,ev,ep,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return false end
	local g=Group.FromCards(tc,c)
	if lanp.U("效果处理",Duel.Destroy,g,{"EFF"})>0 and lang.GetFilter(tp,"P","IsName+Not",{"黄昏教廷神子·辛勒斯",c},1) then
		local sg=lang.GetFilter(tp,"P","IsName+Not",{"黄昏教廷神子·辛勒斯",c})
		if #sg==0 then return false end
		lanp.U("效果处理",Duel.Destroy,g,{"EFF"})
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end