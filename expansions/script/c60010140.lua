--烦恼着，幸福着
function c60010140.initial_effect(c)
	aux.AddCodeList(c,60010059)
	aux.AddCodeList(c,60010029)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010140.condition)
	e0:SetOperation(c60010140.activate)
	c:RegisterEffect(e0)
	--code
	local ge1=Effect.CreateEffect(c)
	ge1:SetCategory(CATEGORY_DISABLE)
	ge1:SetType(EFFECT_TYPE_QUICK_O)
	ge1:SetCode(EVENT_CHAINING)
	ge1:SetRange(LOCATION_MZONE)
	ge1:SetCountLimit(1)
	ge1:SetCondition(c60010140.discon)
	ge1:SetTarget(c60010140.distg)
	ge1:SetOperation(c60010140.disop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,60010059))
	e1:SetLabelObject(ge1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010140)
	e2:SetCondition(c60010140.spcon)
	e2:SetTarget(c60010140.sptg)
	e2:SetOperation(c60010140.spop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010140.checkop)
	c:RegisterEffect(e3)
end
function c60010140.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not SpaceCheck then
		SpaceCheck={}
		for i=0,1 do
			local g=Duel.GetMatchingGroup(nil,i,LOCATION_HAND+LOCATION_DECK,0,nil)
			if #g==g:GetClassCount(Card.GetCode) then
				SpaceCheck[i]=true
			end
		end
	end
end
function c60010140.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010140.thfilter(c)
	return c:IsCode(60010059,60010029) and c:IsAbleToHand()
end
function c60010140.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010140.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010140,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010140.disfilter(c,race,attr)
	return c:IsRace(race) and c:IsAttribute(attr) and c:IsFaceup()
end
function c60010140.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c60010140.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,rc:GetRace(),rc:GetAttribute()) and Duel.IsChainDisablable(ev)
end
function c60010140.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c60010140.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c60010140.ownerfilter(c,tp)
	return c:IsCode(60010059) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010140.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010140.ownerfilter,1,nil,tp)
end
function c60010140.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c60010140.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(c60010140.disfilter,tp,LOCATION_MZONE,0,1,nil,c:GetRace(),c:GetAttribute())
end
function c60010140.spop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:IsExists(c60010140.spfilter,1,nil,e,p) and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(p,c60010140.spfilter,1,1,nil,e,p)
		if #sg>0 then
			Duel.DisableShuffleCheck(true)
			Duel.SpecialSummon(sg,0,p,p,false,false,POS_FACEUP)
		end
	end
end
