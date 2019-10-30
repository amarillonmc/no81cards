--终焉邪魂 暗尸
function c30000027.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c30000027.matfilter,1,1)
	c:EnableReviveLimit()
	--atkup
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000027,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,30000027)
	e1:SetTarget(c30000027.sptg)
	e1:SetOperation(c30000027.spop)
	c:RegisterEffect(e1)
	--link summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(30000027,1))
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_REMOVE)
	e7:SetCountLimit(1,30000028)
	e7:SetCondition(c30000027.con0)
	e7:SetTarget(c30000027.target0)
	e7:SetOperation(c30000027.activate)
	c:RegisterEffect(e7)
end
function c30000027.matfilter(c)
	return c:IsLinkSetCard(0x920) and c:IsLinkAbove(2)
end
function c30000027.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c30000027.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanRemove(tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,2)
end

function c30000027.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==1 and Duel.IsPlayerCanRemove(p) then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local reg=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,tp,LOCATION_HAND,0,2,2,nil)
		Duel.Remove(reg,POS_FACEUP,REASON_EFFECT)
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(30000027,1)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function c30000027.filter(c,e,tp)
	return c:IsSetCard(0x3920) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c30000027.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c30000027.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c30000027.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c30000027.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0) 
end

function c30000027.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
   end
end