--永远亭启动 永恒假面之月
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	--summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCountLimit(1)
	e3:SetCondition(s.ntcon)
	e3:SetTarget(s.nttg)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1108)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.drcon)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
	if not s.global_flag then
		s.global_flag=true
		s[0]={}
		for i=1,65535 do
			table.insert(s[0],i)
		end
		--self destroy
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DRAW)
		ge2:SetOperation(s.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if re and re:GetHandler():IsSetCard(0x863) then return end
		if tc:IsCode(id) and tc:IsLocation(LOCATION_HAND+LOCATION_SZONE) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0
end

function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsLevelAbove(7) 
end
function s.drfilter(c,tp)
	return c:IsSetCard(0x863) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.drfilter,1,e:GetHandler(),tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.rmfilter(c,d)
	return c:IsAbleToRemove() and c:IsSetCard(d)
end
function s.filter1(c,e,tp)
	if not c:IsType(TYPE_XYZ) then return end
	local dg=Group.CreateGroup()
	local g=nil
	for i,setcard in ipairs(s[0]) do
		if c:IsSetCard(setcard) then
			g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,setcard)
			dg:Merge(g)
		end
	end
	local rk=c:GetRank()
	return #dg>0 and rk>0 and c:IsFaceup() and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) 
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,#dg)
end
function s.filter2(c,e,tp,mc,rk)
	if c:GetOriginalCode()==6165656 and not mc:IsCode(48995978) then return false end
	local rank=mc:GetRank()
	local kk=rank+rk
	return c:IsRankBelow(kk) and c:GetRank()>rank and mc:IsCanBeXyzMaterial(c) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fselect(g,e,tp,mc)
	return Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,mc,#g)
end
function s.filter3(c,e,tp,mc,rk)
	if c:GetOriginalCode()==6165656 and not mc:IsCode(48995978) then return false end
	local rank=mc:GetRank()
	local kk=rank+rk
	return c:IsRank(kk) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local d=Group.CreateGroup()
	local g=nil
	for i,setcard in ipairs(s[0]) do
		if tc:IsSetCard(setcard) then
			g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,setcard) 
		end
	end
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_XYZ)
	local tg,rk=sg:GetMaxGroup(Card.GetRank)
	--Debug.Message(rk)
	local ct=math.min(#g,rk-tc:GetRank())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,s.fselect,false,1,ct,e,tp,tc)
	local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local egg=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,ct)
		local sc=egg:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end