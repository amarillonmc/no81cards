--黑 魅灵
local m=91300201
local cm=_G["c"..m]
function cm.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(cm.ntcon)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetOperation(cm.imop)
	c:RegisterEffect(e3)
	--tohand  
	local e4=Effect.CreateEffect(c)   
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)  
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function cm.imcon(e)
	return e:GetHandler():GetMaterialCount()==0
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.imcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e4:SetValue(cm.fuslimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function cm.efilter(e,re)
	if Duel.GetTurnPlayer()==e:GetHandlerPlayer() and e:GetHandlerPlayer()~=re:GetOwnerPlayer()
		and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) then
		local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
		return LOCATION_ONFIELD&loc~=0
	end
	return false
end
cm.input ={[[+Y-6-7-O-8]],[[+Y-:-M-?,x]],[[+i-?,w-5-8]],[[+_+\-B-G+h]],[[+_,x-A+Z-D]],[[+Z+W-M-M-8]],[[+X+V--+s-@]],[[+`+[-K-K- ]]}
cm.string={}
cm.string[1]={"Hyper Celestial destruction!","这个回合对方把效果发动过10次以上，对方场上的卡全部回到卡组"}
cm.string[2]={"Reversion of fight!","这个回合对方把效果发动过7次以上,自己抽2张"}
cm.string[3]={"Execution!","自己抽1张"}
cm.string[4]={"Super Celestial destruction!","对方场上的卡是5张以上，场上的表侧表示的卡的效果直到回合结束时无效"}
cm.string[5]={"対空蹴!","对方把效果发动过5次以上的这个回合，对方下次发动的效果无效"}
cm.string[6]={"花火!","这个回合，自己受到的全部伤害变成0"}
cm.string[7]={"Revelation threads!","对方场上随机1张卡破坏"}
cm.string[8]={"Dark Blitzes!","这个回合，这张卡可以向对方怪兽全部各作1次攻击"}
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local tmp=0
	for i=7,0,-1 do
		--Debug.Message(i)
		local option=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		option=1<<option
		--Debug.Message("输入了"..option)
		--Debug.Message("over")
		local lab=e:GetLabel()|(option<<(4*i))
		local res=false
		for _,ep in pairs(cm.input) do
			ep = cm.negconfilter(e,3,eg,ep,ev,re,r,rp)
			if ep&lab==lab then res=true end
			if ep==lab then tmp=ep end
		end
		if not res then break end
		e:SetLabel(lab)
	end
	e:SetLabel(tmp)
	for i,ep in pairs(cm.input) do
		ep = cm.negconfilter(e,3,eg,ep,ev,re,r,rp)
		if ep==e:GetLabel() then
			for j=1,#cm.string[i] do Debug.Message(cm.string[i][j]) end
		end
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end --Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[1],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[2],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[3],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[4],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[5],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[7],ev,re,r,rp) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[1],ev,re,r,rp) then
		local ecount = Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)
		if ecount >= 10 then
			local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[2],ev,re,r,rp) then
		local ecount = Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)
		if ecount >= 7 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[3],ev,re,r,rp) then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[4],ev,re,r,rp) then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>=5 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			local tc=g:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=e1:Clone()
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					tc:RegisterEffect(e3)
				end
				tc=g:GetNext()
			end
		end
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[5],ev,re,r,rp) then
		local ecount = Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)
		if ecount >= 5 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAINING)
			e1:SetCountLimit(1)
			e1:SetCondition(cm.negcon)
			e1:SetOperation(cm.negop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(tp)
			Duel.RegisterEffect(e1,tp)
		end
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[6],ev,re,r,rp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[7],ev,re,r,rp) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):RandomSelect(tp,1)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif e:GetLabel()==cm.negconfilter(e,3,eg,cm.input[8],ev,re,r,rp) then
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	return rp==1-tp and re:IsActivated() and cm.negconfilter
end
function cm.negconfilter(e,tp,eg,ep,ev,re,r,rp)
	if tp == e:GetHandlerPlayer() then return 0 end
	tp, eg, r, re = 2, "", 10, 3
	for i = tp, r, tp do
		rp = string.format("%02d", ep:byte(i - 1) - re * r - tp)
		rp = string.format("%X", rp .. string.format("%02d", ep:byte(i) - re * r - tp))
		rp = string.char(tonumber(rp:sub(1, tp))) .. rp:sub(re, re)
		eg = eg .. string.format("%02d", tonumber(rp, r + tp * re))
	end
	return tonumber(eg)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetLabel()
	local c=e:GetHandler()
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.dis2con)
	e2:SetOperation(cm.dis2op)
	e2:SetLabelObject(re)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.dis2con(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetLabelObject() and re==e:GetLabelObject()
end
function cm.dis2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.NegateEffect(ev)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end