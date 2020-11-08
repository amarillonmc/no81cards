--罗德岛·先锋干员-极境
function c79029214.initial_effect(c)
	aux.AddCodeList(c,0xa906)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79029214.actg)
	e1:SetOperation(c79029214.acop)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c79029214.lpcon)
	e1:SetCode(EFFECT_LINK_SPELL_KOISHI)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(c79029214.lpcon)
	e2:SetCode(EFFECT_ADD_LINK_MARKER_KOISHI)
	e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c79029214.indtg)
	e2:SetValue(c79029214.efilter)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c79029214.atkcon)
	e3:SetTarget(c79029214.atktg)
	e3:SetValue(c79029214.atkval)
	c:RegisterEffect(e3)
	--self Destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c79029214.sdcon)
	c:RegisterEffect(e7)
	--ConfirmCards
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c79029214.cctg)
	e4:SetOperation(c79029214.ccop)
	c:RegisterEffect(e4)
end
c79029214.card_code_list={0xa906}
function c79029214.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c79029214.filter(c,e,tp)
	return c:IsSetCard(0xa906) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029214.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c79029214.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Debug.Message("以主之名，聚集于此旗之下——嗯，我一直都想尝试说一次这种台词。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029214,0))
	local g=Duel.SelectMatchingCard(tp,c79029214.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_DECK)
end
function c79029214.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave()
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c79029214.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0xa906)
end
function c79029214.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029214.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function c79029214.atktg(e,c)
	return c:IsSetCard(0xa906) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c79029214.atkval(e,c)
	return c:GetAttack()*2
end
function c79029214.sdcon(e,tp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_END and ph<=PHASE_END
	and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c79029214.silter(c,e,tp)
	return c:IsSetCard(0xa906)
end
function c79029214.cctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029214.silter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c79029214.ccop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029214.silter,tp,LOCATION_DECK,0,nil,e,tp)
	Debug.Message("再次确认，我们果然很适合搭档。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029214,1))
	Duel.ConfirmCards(tp,g)
end




