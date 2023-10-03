--异梦街灯旁的舞者-跳舞子
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400060.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,2)
	--summon limit
	yume.AddYumeSummonLimit(c,2)
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c71400060.filter1)
	c:RegisterEffect(e1)
	local e1a=Effect.CreateEffect(c)
	e1a:SetType(EFFECT_TYPE_FIELD)
	e1a:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1a:SetRange(LOCATION_MZONE)
	e1a:SetValue(c71400060.filter1)
	c:RegisterEffect(e1a)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400060,0))
	e2:SetCountLimit(1,71400060)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_GRAVE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(c71400060.con2)
	e2:SetCost(c71400060.cost2)
	e2:SetTarget(c71400060.tg2)
	e2:SetOperation(c71400060.op2)
	c:RegisterEffect(e2)
end
function c71400060.filter1(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsSetCard(0x714) and tc:IsType(TYPE_XYZ)
end
function c71400060.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c71400060.filterc2(c)
	return c:IsSetCard(0xe714) and (c:IsReleasable() or c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c71400060.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c71400060.filterc2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local g=Duel.SelectReleaseGroupEx(tp,c71400060.filterc2,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c71400060.filter2(c,e,tp)
	if c:IsType(TYPE_LINK) then
		return false
	else
		local flag=false
		local num=0
		if c:IsType(TYPE_XYZ) then
			flag=true
			num=c:GetRank()
		else
			flag=false
			num=c:GetLevel()
		end
		return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71400060.filter2a),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,num,e,tp,flag)
	end
end
function c71400060.filter2a(c,mnum,e,tp,flag)
	if c:IsType(TYPE_XYZ)~=flag then return false end
	return (flag and c:IsRank(mnum) or not flag and c:IsLevel(mnum)) and c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400060.filter2b(c)
	return c:IsFaceup() and c:IsSetCard(0x714)
end
function c71400060.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400060.filter2b,tp,LOCATION_MZONE,0,1,nil) end
end
function c71400060.op2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71400060.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(71400060,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400060.filter2),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			local tc=g1:GetFirst()
			local flag=false
			local num=0
			if tc:IsType(TYPE_XYZ) then
				flag=true
				num=tc:GetRank()
			else
				flag=false
				num=tc:GetLevel()
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400060.filter2a),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,tc,num,e,tp,flag)
			g1:Merge(g2)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local g=Duel.GetMatchingGroup(c71400060.filter2b,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end