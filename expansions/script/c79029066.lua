--企鹅物流·重装干员-拜松
function c79029066.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029066.ffilter,2,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c79029066.atklimit)
	c:RegisterEffect(e2) 
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,09029066)
	e3:SetCondition(c79029066.condition2)
	e3:SetOperation(c79029066.operation2)
	c:RegisterEffect(e3)
	--to hand 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,09029066)
	e4:SetTarget(c79029066.thtg)
	e4:SetOperation(c79029066.thop)
	c:RegisterEffect(e4)
end
function c79029066.ffilter(c)
	return c:IsFusionSetCard(0xa900)
end
function c79029066.atklimit(e,c)
	return c~=e:GetHandler()
end
function c79029066.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec==e:GetHandler()
end
function c79029066.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	local c=e:GetHandler()
	Debug.Message("再坚持一下吗？我知道了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029066,1))
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end
function c79029066.thfil(c)
	return c:IsAbleToHand() and c:IsSetCard(0xa900)
end
function c79029066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029066.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c79029066.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029066.thfil,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Debug.Message("现场指挥的话......我稍微有些经验。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029066,0))
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end 





