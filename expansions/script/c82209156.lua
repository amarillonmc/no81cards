--玄化
local m=82209156
local cm=c82209156
if not cm.effects then cm.effects={} end
if not cm.ranges then cm.ranges={} end

function cm.regfilter(c)
	return c:IsOriginalSetCard(0x105) and c:IsType(TYPE_MONSTER)
end

function cm.fccon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsLocation(LOCATION_REMOVED) and Duel.IsPlayerAffectedByEffect(tp,m)
end

function cm.fccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetLabel(e:GetHandler():GetOriginalCode())
	e1:SetValue(cm.countlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)  
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.countlimit(e,re,rp) 
	local rc=re:GetHandler()
	return rc:GetOriginalCode()==e:GetLabel() and re:GetLabel()==114514
end  

if not cm.start then
	cm.start=true

	cm.set_range=Effect.SetRange
	Effect.SetRange=function (e,range)
		cm.set_range(e,range)
		table.insert(cm.effects,e)
		table.insert(cm.ranges,range)
	end

	cm.register_effect=Card.RegisterEffect
	Card.RegisterEffect=function (c,e,...)
		cm.register_effect(c,e,...)

		if not cm.regfilter(c) then return end

		--check whether act in removed
		local act_in_removed=false
		local i=1
		while i<=#cm.effects do
			if cm.effects[i]==e and i<=#cm.ranges and cm.ranges[i]==LOCATION_REMOVED then
				act_in_removed=true
				break
			end
			i=i+1
		end

		if act_in_removed
			and e:IsHasType(EFFECT_TYPE_TRIGGER_O) 
			and e:GetCode()==EVENT_PHASE+PHASE_STANDBY 
			and e:GetOperation() 
			and e:GetOwner()==c then 
			
			--def new effect
			local e114=Effect.CreateEffect(c)
			e114:SetDescription(aux.Stringid(m,0))
			e114:SetType(EFFECT_TYPE_QUICK_O)
			e114:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e114:SetCode(EVENT_FREE_CHAIN)
			e114:SetRange(LOCATION_REMOVED)
			e114:SetHintTiming(TIMINGS_CHECK_MONSTER)
			e114:SetLabel(114514)
			e114:SetCondition(cm.fccon)
			e114:SetCost(cm.fccost)

			if e:GetTarget() then
				local old_target=e:GetTarget()
				--def new target
				local new_target=function (e,tp,eg,ep,ev,re,r,rp,chk,...)
					if chk==0 then return e:GetHandler():IsAbleToDeck() and old_target(e,tp,eg,ep,ev,re,r,rp,0,...) end
					return old_target(e,tp,eg,ep,ev,re,r,rp,chk,...)
				end
				e114:SetTarget(new_target)
			else
				--def new target
				local todeck_target=function (e,tp,eg,ep,ev,re,r,rp,chk,...)
					if chk==0 then return e:GetHandler():IsAbleToDeck() end
				end
				e114:SetTarget(todeck_target)
			end

			if e:GetOperation() then
				local old_operation=e:GetOperation()
				--def new operation
				local new_operation=function (e,tp,eg,ep,ev,re,r,rp,...)
					old_operation(e,tp,eg,ep,ev,re,r,rp,...)
					if e:GetHandler():IsLocation(LOCATION_REMOVED) and e:GetHandler():IsAbleToDeck() then
						Duel.BreakEffect()
						Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
					end
				end
				e114:SetOperation(new_operation)
			end

			cm.register_effect(c,e114,...)
		end
	end

	local g=Duel.GetMatchingGroup(cm.regfilter,tp,0xff,0xff,nil)
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetOriginalCode()
		local ccode=_G["c"..code]
		if not cm.initial_effect then cm.initial_effect=aux.TRUE end
		tc:ReplaceEffect(82209156,0)
		if ccode.initial_effect then ccode.initial_effect(tc) end
		tc=g:GetNext()
	end
	--Debug.Message("此卡会爆不明红字，但仍然可以正常使用")
	--Debug.Message("至少目前暂未发现实质性bug，无需反馈")
	--Debug.Message("如有能力进行修复也可联系作者")
end

function cm.initial_effect(c)
	if c:GetOriginalCode()==m then 
		--Activate  
		local e1=Effect.CreateEffect(c)  
		e1:SetCategory(CATEGORY_REMOVE)  
		e1:SetType(EFFECT_TYPE_ACTIVATE)  
		e1:SetCode(EVENT_FREE_CHAIN)   
		e1:SetCost(cm.cost)
		e1:SetTarget(cm.tg)  
		e1:SetOperation(cm.act)  
		c:RegisterEffect(e1) 
		--register
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_FIELD)  
		e2:SetCode(m)  
		e2:SetRange(LOCATION_SZONE)  
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
		e2:SetTargetRange(1,0)  
		c:RegisterEffect(e2)  
	end
end
function cm.cfilter(c,tp)
	local lv=c:GetLevel()
	local dg=Duel.GetDecktopGroup(tp,lv)
	return c:IsSetCard(0x105) and c:IsType(TYPE_MONSTER) 
		and c:IsAbleToRemoveAsCost() 
		and lv>=1 and lv<=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		and dg:FilterCount(Card.IsAbleToRemove,nil,tp)==lv
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,e:GetLabel(),tp,LOCATION_DECK)
	end
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local ct=e:GetLabel()
	if (not c:IsRelateToEffect(e)) or ct<=0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)  
	Duel.DisableShuffleCheck()  
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetValue(cm.actlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end  
function cm.actlimit(e,re,rp)  
	local rc=re:GetHandler()  
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard(0x105) 
end  