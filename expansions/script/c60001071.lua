--莜莱妮卡 初生之阳
local m=60001071
local cm=_G["c"..m]

function cm.initial_effect(c)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.shcost)
	e2:SetTarget(cm.shtg)
	e2:SetOperation(cm.shop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,160001071)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end

function cm.filter(c,hg,dg)
	return c:IsPosition(POS_FACEDOWN) and 
	((c:IsOriginalCodeRule(60001076) and hg:IsExists(cm.costiefilter,1,nil) and dg:IsExists(cm.costiefilter,1,nil)) or
	(c:IsOriginalCodeRule(60001077) and hg:IsExists(cm.costiefilter,1,nil) and dg:IsExists(cm.costiefilter,1,nil)) or
	(c:IsOriginalCodeRule(60001078) and hg:IsExists(Card.IsType,1,nil,TYPE_TUNER) and dg:IsExists(Card.IsType,1,nil,TYPE_TUNER)))
end

function cm.costiefilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x62d)
end

function cm.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,hg,dg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,hg,dg)
	local g1=g:Select(tp,1,1,nil)
	if g1 then 
		Duel.ConfirmCards(1-tp,g1)
	end
	e:SetLabel(g1:GetFirst():GetOriginalCodeRule())
end

function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,nil,tp,LOCATION_DECK)
end

function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local hg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND,0,nil)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_DECK,0,nil)
	if code==60001076 and hg:IsExists(cm.costiefilter,1,nil) and dg:IsExists(cm.costiefilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.costiefilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,cm.costiefilter,tp,LOCATION_DECK,0,1,1,nil)
		g:Merge(g1)
		Duel.SendtoGrave(g,REASON_EFFECT)
	elseif code==60001077 and hg:IsExists(cm.costiefilter,1,nil) and dg:IsExists(cm.costiefilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.costiefilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,cm.costiefilter,tp,LOCATION_DECK,0,1,1,nil)
		g:Merge(g1)
		Duel.SendtoGrave(g,REASON_EFFECT)
	elseif code==60001079 and hg:IsExists(Card.IsType,1,nil,TYPE_TUNER) and dg:IsExists(Card.IsType,1,nil,TYPE_TUNER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_TUNER)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_TUNER)
		g:Merge(g1)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function cm.sptfilter(c,e,tp)
	return c:IsOriginalCodeRule(24094653) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.sptfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sptfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then 
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_RACE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(RACE_WARRIOR)
		e3:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetValue(4)
		e4:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_TYPE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetValue(TYPE_NORMAL+TYPE_TUNER+TYPE_MONSTER)
		e5:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetValue(0xff)
		e6:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e6,true)
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP) and tc:IsLocation(LOCATION_MZONE) then
			tc:RegisterFlagEffect(0,RESET_EVENT+0xff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		end
	end
end

