--幻想曲 斩断因果之刃
function c60150503.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150503,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c60150503.spcon)
	e1:SetTarget(c60150503.sptg)
	e1:SetOperation(c60150503.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetRange(LOCATION_OVERLAY)
	e3:SetCondition(c60150503.efcon)
	e3:SetOperation(c60150503.efop)
	c:RegisterEffect(e3)
	--封特招
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	--e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e4:SetCondition(c60150503.descon)
	--e4:SetOperation(c60150503.desop)
	--c:RegisterEffect(e4)
end
function c60150503.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c60150503.desop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150503.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150503.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and bit.band(r,REASON_DISCARD)~=0
end
function c60150503.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150503.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150503.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE) and not c:IsSetCard(0xab20)
end
function c60150503.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c60150503.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(60150503,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_LEAVE)
	e1:SetCondition(c60150503.eqcon)
	e1:SetTarget(c60150503.eqtg)
	e1:SetOperation(c60150503.activate)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c60150503.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c60150503.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetBattleTarget() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150503.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetBattleTarget():GetCode()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,code)
	Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	local deck=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_EXTRA)
	if deck:GetCount()~=0 then Duel.ShuffleDeck(1-tp) end
end