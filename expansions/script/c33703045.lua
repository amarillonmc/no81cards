--虚·虚拟YouTuber Evil Neuro
local m=33703045
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--Senya.AddXyzProcedureCustom(c,aux.FilterBoolFunction(Card.IsSetCard,0x445),function(g) return g:GetClassCount(Card.GetCode)==3 end,3,3)
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()  
	c:EnableCounterPermit(0x1010)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK) 
	e1:SetValue(cm.valcheck)
	c:RegisterEffect(e1)
	--xzy success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	e2:SetLabelObject(e1)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.addcon)
	e3:SetOperation(cm.addop)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EVENT_DRAW)
	e33:SetCondition(cm.addcon1)
	c:RegisterEffect(e33)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.tcon)
	e4:SetCost(cm.tcost)
	e4:SetTarget(cm.ttg)
	e4:SetOperation(cm.top)
	c:RegisterEffect(e4)
end
function cm.tcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	return  Duel.GetCurrentPhase()~=PHASE_DRAW and (ct1-ct2)~=0
end
function cm.tcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then  return e:GetHandler():GetCounter(0x1010)>0 end
e:GetHandler():RemoveCounter(tp,0x1010,1,REASON_COST)
end
function cm.ttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if chk==0 then return (ct1-ct2)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct1-ct2,0,0)
end
function cm.top(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	local temp=math.abs(ct1-ct2)
	local deck= Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,deck)
	local g = Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD+LOCATION_DECK,1,temp,nil)
	if g:GetCount()~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function cm.tfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.addcon1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.tfilter,nil,tp)
	return (Duel.GetTurnPlayer~=tp and Duel.GetCurrentPhase()~=PHASE_DRAW and g:GetCount()>0)
end
function cm.addcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.tfilter,nil,tp)
	return Duel.GetTurnPlayer~=tp  and eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.addop(e,tp,eg,ep,ev,re,r,rp)
	 Card.AddCounter(e:GetHandler(),0x1010,1)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	local mt=0
	local tc=g:GetFirst()
	while tc do
		if tc:GetLevel()==5 and (not tc:IsSetCard(0x445)) then
			mt=mt+1
			e:SetLabel(mt)
		end
		tc=g:GetNext()
	end

end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
	and e:GetLabelObject():GetLabel()==3
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
			if e:GetLabelObject():GetLabel()==3 then
			local c=e:GetHandler()
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetValue(RESET_TURN_SET)
			--c:RegisterEffect(e4)
			--Duel.AdjustInstantly(c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(c:GetBaseAttack()+1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(c:GetBaseDefense()+1500)
			c:RegisterEffect(e2,true)
			end
end