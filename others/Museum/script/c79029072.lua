--喀兰贸易·近卫干员-银灰
function c79029072.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,c79029072.lcheck)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029072)
	e1:SetCondition(c79029072.spcon)
	e1:SetTarget(c79029072.sptg)
	e1:SetOperation(c79029072.spop)
	c:RegisterEffect(e1)
	--immuse
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029072,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029072.imcon)
	e2:SetCost(c79029072.imcost)
	e2:SetTarget(c79029072.imtg)
	e2:SetOperation(c79029072.imop)
	c:RegisterEffect(e2)
	--draw 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,19029072)
	e3:SetTarget(c79029072.drtg)
	e3:SetOperation(c79029072.drop)
	c:RegisterEffect(e3)
end
function c79029072.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1906)
end
function c79029072.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029072.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLinkBelow(3) and c:IsSetCard(0x1906)
end
function c79029072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c79029072.spfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c79029072.spop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(c79029072.spfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	Debug.Message("客随主便，按你的想法安排就好。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029072,0)) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
function c79029072.imcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c79029072.ctfil(c)
	return c:IsSetCard(0x1906) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c79029072.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029072.ctfil,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029072.ctfil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029072.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029072.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("战场之上，善良是无法拯救他人的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029072,1)) 
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local tc=g:GetFirst()
	while tc do
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029072.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e1:SetOwnerPlayer(tp)
	tc:RegisterEffect(e1)   
	tc=g:GetNext()
	end
end
function c79029072.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c79029072.lxfil(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
function c79029072.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	if chk==0 then return g:IsExists(c79029072.lxfil,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c79029072.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	if g:GetCount()<=0 then return end
	Debug.Message("有什么想法？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029072,2)) 
	p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,g:GetCount(),REASON_EFFECT)
end





