--黑暗之主班恩
function c87531060.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(c87531060.condition)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c87531060.condition)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87531060,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c87531060.spcon)
	e3:SetTarget(c87531060.sptg)
	e3:SetOperation(c87531060.spop)
	c:RegisterEffect(e3)
end
function c87531060.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetLP(tp)<=4000
end
function c87531060.spcfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		 and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function c87531060.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c87531060.spcfilter,1,nil,tp)
end
function c87531060.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c87531060.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c87531060.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and not b2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(87531060,1))
		op=1
	end
	if b2 and not b1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(87531060,2))
		op=2
	end
	if b1 and b2 then
		op=aux.SelectFromOptions(1-tp,
			{b1,aux.Stringid(87531060,1)},
			{b2,aux.Stringid(87531060,2)})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function c87531060.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c87531060.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
