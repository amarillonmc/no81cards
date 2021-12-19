--极光烈姬 塞拉丝·比娅莱特
local m=40010236
local cm=_G["c"..m]
cm.named_with_AuroraBattlePrincess=1
cm.named_with_Seraph=1
function cm.AuroraBattlePrincess(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AuroraBattlePrincess
end
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.mfilter,7,4)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tgcon1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.tgcost)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.tgcon2)
	e3:SetCost(cm.tgcost)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.regcon)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
end
function cm.mfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,40009707)
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_SZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.GetTurnPlayer()==1-tp then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.xctgfilter(c)
	return c:IsFaceup() and c:IsCode(40009623) 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local g0=Duel.GetMatchingGroup(cm.xctgfilter,tp,LOCATION_FZONE,0,nil)
	if op==0 then
		local g1=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_MZONE,nil)
		if g0:GetCount()>0 and g1:GetCount()>0 then
			local g2=Duel.SelectMatchingCard(tp,cm.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
			Duel.HintSelection(g2)
			--local sg=g1:RandomSelect(1-tp,1)
			local tc=g2:GetFirst()
			Duel.Overlay(tc,g1)
		end
	elseif op==1 then
		local g11=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_SZONE,nil)
		if g0:GetCount()>0 and g11:GetCount()>0 then
			local g2=Duel.SelectMatchingCard(tp,cm.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
			Duel.HintSelection(g2)
			--local sg=g1:RandomSelect(1-tp,1)
			local tc=g2:GetFirst()
			Duel.Overlay(tc,g11)
		end
	else
		local g111=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,nil)
		if g0:GetCount()>0 and g111:GetCount()>0 then
			local g2=Duel.SelectMatchingCard(tp,cm.xctgfilter,tp,LOCATION_FZONE,0,1,1,nil)
			Duel.HintSelection(g2)
			--local sg=g1:RandomSelect(1-tp,1)
			local tc=g2:GetFirst()
			Duel.Overlay(tc,g111)
		end
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xctgfilter,tp,LOCATION_FZONE,0,nil)
	local tc=g:GetFirst()
	return tc:GetOverlayCount()>=10
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0
	   
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsCanOverlay,1-tp,LOCATION_HAND,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end