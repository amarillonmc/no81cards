--人理之星 圣女贞德
function c22024960.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--sum limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetCondition(c22024960.sumcon)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024960,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22024960)
	e1:SetCondition(c22024960.thcon)
	e1:SetTarget(c22024960.thtg)
	e1:SetOperation(c22024960.thop)
	c:RegisterEffect(e1)
	--ex
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22024960.imcon)
	e2:SetValue(c22024960.efilter)
	c:RegisterEffect(e2)
	--ex
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22024960.imcon)
	e3:SetValue(22020410)
	c:RegisterEffect(e3)
	--ex
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22024960.imcon)
	e4:SetValue(5000)
	c:RegisterEffect(e4)
	--l r
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(c22024960.lrcon)
	e5:SetValue(1250)
	c:RegisterEffect(e5)
	--l r
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(c22024960.lrcon)
	e6:SetTarget(c22024960.imtg)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7)
	--c
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCondition(c22024960.cocon)
	e8:SetTarget(c22024960.tgtg)
	e8:SetValue(c22024960.efilter)
	c:RegisterEffect(e8)
	--cannot activate effect
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(0,1)
	e9:SetCondition(c22024960.actlimcon)
	e9:SetValue(1)
	c:RegisterEffect(e9)
end
function c22024960.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>2500
end
function c22024960.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c22024960.thfilter(c)
	return c:IsSetCard(0xff1) and c:IsAbleToHand()
end
function c22024960.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024960.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2500)
end
function c22024960.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22024960.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			Duel.Recover(tp,2500,REASON_EFFECT)
		end
	end
end
function c22024960.imcon(e)
	return e:GetHandler():GetSequence()>4
end
function c22024960.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c22024960.lrcon(e)
	return e:GetHandler():GetSequence()==0 or e:GetHandler():GetSequence()==4
end
function c22024960.imtg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c22024960.tgtg(e,c)
	return c~=e:GetHandler()
end
function c22024960.cocon(e)
	return e:GetHandler():GetSequence()==2
end
function c22024960.actlimcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandlerPlayer()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		and (c:GetSequence()==1 or c:GetSequence()==3)
end