--七仟陌
function c71000100.initial_effect(c)
	c:EnableReviveLimit()
   -- spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c71000100.splimit)
	c:RegisterEffect(e1)
  --  cannot releaase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	--atk,def
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(c71000100.val)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e10)   
	--
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_TODECK)
	e22:SetType(EFFECT_TYPE_QUICK_O)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCode(EVENT_FREE_CHAIN)
	e22:SetHintTiming(0,TIMING_END_PHASE)
	e22:SetCountLimit(1)
	e22:SetCost(c71000100.cost)
	e22:SetTarget(c71000100.tg)
	e22:SetOperation(c71000100.op)
	c:RegisterEffect(e22)
end
function c71000100.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(71000101,71000102)
end
function c71000100.val(e,c)
	return c:GetOverlayCount()*300
end
function c71000100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function c71000100.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,e:GetLabel(),0,0)
end
function c71000100.stfilter(c)
	return c:IsSetCard(0xe73) and c:IsSSetable() 
end
function c71000100.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,CATEGORY_TODECK,REASON_EFFECT)
		local st=Duel.GetMatchingGroup(c71000100.stfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71000100,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=st:Select(tp,1,ct,nil)
			Duel.SSet(tp,sg)
		end
	end
end