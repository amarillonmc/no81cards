--真武神-荒樔田
function c40009351.initial_effect(c)
	c:SetUniqueOnField(1,0,40009351)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009351,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c40009351.spcon)
	e1:SetTarget(c40009351.sptg)
	e1:SetOperation(c40009351.spop)
	c:RegisterEffect(e1)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009351,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,40009351)
	e3:SetCondition(c40009351.drcon)
	e3:SetTarget(c40009351.drtg)
	e3:SetOperation(c40009351.drop)
	c:RegisterEffect(e3)	
end
function c40009351.cfilter(c,tp)
	return c:IsSetCard(0x88) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE+LOCATION_GRAVE)
end
function c40009351.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009351.cfilter,1,nil,tp)
end
function c40009351.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40009351.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c40009351.regfilter(c,tp)
	return c:IsSetCard(0x88) and c:IsControler(tp) 
		and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c40009351.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009351.regfilter,1,nil,tp)
end
function c40009351.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c40009351.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
