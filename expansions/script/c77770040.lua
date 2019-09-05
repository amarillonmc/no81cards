--鬼化 灶门祢豆子(注：狸子DIY)
function c77770040.initial_effect(c)
    --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77770040,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,77770040)
	e1:SetCondition(c77770040.descon)
	e1:SetTarget(c77770040.destg)
	e1:SetOperation(c77770040.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c77770040.descon2)
	c:RegisterEffect(e2)
		--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c77770040.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77770040,0))
	e5:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c77770040.negcon)
	e5:SetTarget(c77770040.negtg)
	e5:SetOperation(c77770040.negop)
	c:RegisterEffect(e5)
	end
function c77770040.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c77770040.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c77770040.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c77770040.filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77770040.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c77770040.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c77770040.cfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsPreviousLocation(LOCATION_GRAVE)
		and c:GetPreviousControler()==tp
end
function c77770040.descon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77770040.cfilter,1,nil,tp)
end
function c77770040.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_ZOMBIE)
end
function c77770040.indcon(e)
	return Duel.IsExistingMatchingCard(c77770040.cfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c77770040.negcon(e,tp,eg,ep,ev,re,r,rp)
	local race,code1,code2=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_RACE,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2)
	return race&RACE_ZOMBIE>0 and code1~=39185163 and code2~=39185163
end
function c77770040.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
end
function c77770040.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
	   local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	    Duel.ConfirmCards(tp,g)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,1500,REASON_EFFECT)
	end
end