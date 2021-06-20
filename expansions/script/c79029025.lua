--龙门·近卫干员-陈
function c79029025.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c79029025.ffilter,3,99,true)
	--th
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029025)
	e1:SetTarget(c79029025.thtg)
	e1:SetOperation(c79029025.thop)
	c:RegisterEffect(e1)	
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--double atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c79029025.ffilter(c)
	return c:IsFusionType(TYPE_RITUAL+TYPE_XYZ+TYPE_SYNCHRO+TYPE_LINK) and c:IsSetCard(0xa900)
end
function c79029025.thfil(c) 
	return c:IsAbleToHand() and (c:IsSetCard(0xb90d) or c:IsSetCard(0xc90e))
end
function c79029025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029025.thfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029025.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029025.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("各位，记住，只有相互配合，才能高效行动。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029025,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and c:GetMaterialCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(79029025,0)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,c:GetMaterialCount(),nil)
	Debug.Message("闪！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029025,2))
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.Damage(1-tp,dg:GetCount()*800,REASON_EFFECT)
	end
end
















