--维多利亚·特种干员-贝娜
function c79029477.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029477)
	e1:SetCondition(c79029477.tgcon)
	e1:SetTarget(c79029477.tgtg)
	e1:SetOperation(c79029477.tgop)
	c:RegisterEffect(e1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029477,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,19029477)
	e1:SetCondition(c79029477.condition)
	e1:SetTarget(c79029477.target)
	e1:SetOperation(c79029477.operation)
	c:RegisterEffect(e1)
end
function c79029477.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029477.tgfil(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER)
end
function c79029477.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029477.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c79029477.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029477.tgfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("哼哼。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029477,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if tc:IsSetCard(0xa904) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79029477,0)) then 
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsCode(79029477) then 
	Debug.Message("安妮有些想法，我来说给大家听。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029477,4))
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029477,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(c79029477.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	else
	Debug.Message("你也想拆这些玩具吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029477,3))
	end
	end
end
function c79029477.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c79029477.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c79029477.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c79029477.operation(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("咔嚓咔嚓。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029477,5))
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetAttack(),REASON_EFFECT)
end




