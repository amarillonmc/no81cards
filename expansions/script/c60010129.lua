--梦应归于何处
function c60010129.initial_effect(c)
	aux.AddCodeList(c,60010028)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010129.condition)
	e0:SetOperation(c60010129.activate)
	c:RegisterEffect(e0)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(60010129)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010129)
	e2:SetCondition(c60010129.drcon)
	e2:SetTarget(c60010129.drtg)
	e2:SetOperation(c60010129.drop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010129.checkop)
	c:RegisterEffect(e3)
end
function c60010129.checkop(e,tp,eg,ep,ev,re,r,rp)
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
function c60010129.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010129.thfilter(c)
	return c:IsCode(60010128) and c:IsAbleToHand()
end
function c60010129.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010129.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010129,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010129.lyfilter(c,tp)
	return c:IsCode(60010128) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010129.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010129.lyfilter,1,nil,tp)
end
function c60010129.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
end
function c60010129.exfilter(c,e,tp,lv)
	return c:IsType(TYPE_XYZ) and c:IsRank(lv) and c:IsRace(RACE_PYRO+RACE_MACHINE+RACE_INSECT) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c60010129.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local ly=eg:Filter(c60010129.lyfilter,nil,tp):GetFirst()
	if ly and Duel.IsExistingMatchingCard(c60010129.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ly:GetLevel()) and not ly:IsImmuneToEffect(e) and Duel.GetLocationCountFromEx(ly:GetControler(),tp,ly)>0 and ly:IsCanBeXyzMaterial(nil) and Duel.SelectYesNo(tp,aux.Stringid(60010129,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c60010129.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ly:GetLevel()):GetFirst()
		sc:SetMaterial(Group.FromCards(ly))
		Duel.Overlay(sc,Group.FromCards(ly))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
