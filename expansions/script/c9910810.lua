--创生之铁
function c9910810.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910810+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910810.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c9910810.drcon)
	e2:SetTarget(c9910810.drtg)
	e2:SetOperation(c9910810.drop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9910810.setcost)
	e3:SetTarget(c9910810.settg)
	e3:SetOperation(c9910810.setop)
	c:RegisterEffect(e3)
end
function c9910810.sumfilter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c9910810.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910810.sumfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910810,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
			local atk=POS_FACEUP_ATTACK 
			local def=POS_FACEDOWN_DEFENSE 
			if (s1 and s2 and Duel.SelectPosition(tp,tc,atk+def)==atk) or not s2 then
				Duel.Summon(tp,tc,true,nil,1)
			else
				Duel.MSet(tp,tc,true,nil,1)
			end
		end
	end
end
function c9910810.rlcfilter(c,tp)
	return c:IsCode(9910801) and c:GetPreviousControler()==tp
end
function c9910810.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910810.rlcfilter,1,nil,tp)
end
function c9910810.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910810.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9910810.rfilter(c,e,tp,mc)
	if not c:IsCode(9910802) then return false end
	if Duel.GetMZoneCount(tp,c,tp)>0 and Duel.IsExistingMatchingCard(c9910810.setfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) then return true end
	local flag=Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and mc:IsLocation(LOCATION_SZONE) and mc:GetSequence()<5
	return Duel.IsExistingMatchingCard(c9910810.setfilter2,tp,LOCATION_DECK,0,1,nil,flag)
end
function c9910810.setfilter1(c,e,tp)
	return c:IsSetCard(0x6951) and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c9910810.setfilter2(c,ignore)
	return c:IsSetCard(0x6961) and not c:IsCode(9910810) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c9910810.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroup(tp,c9910810.rfilter,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910810.rfilter,1,1,c,e,tp,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
end
function c9910810.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c9910810.setfilter(c,e,tp)
	if not c:IsSetCard(0x6951) then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else return not c:IsCode(9910810) and c:IsSSetable() end
end
function c9910810.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9910810.setfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsType(TYPE_MONSTER) then
		res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		if res~=0 then Duel.ConfirmCards(1-tp,tc) end
	else
		Duel.SSet(tp,tc)
	end
end
