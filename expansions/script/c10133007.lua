--波动展开
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local s,id,o = GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,10133001)
	local e1 = rsef.I(c,{id,0},nil,nil,nil,LOCATION_HAND)
	e1:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCondition(s.tfcon)
	e1:SetOperation(s.tfop)
	local e2 = rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{id,1},{1,id},"sp,des","de",
		LOCATION_SZONE,s.descon,nil,nil,s.desop)
	local e3 = rsef.RegisterClone(c,e2,"code",EVENT_SUMMON_SUCCESS)
	local e4 = rsef.STO(c,EVENT_DESTROYED,"sp",{1,id+100},"sp","de",nil,nil,
		rsop.target2(s.reg,s.spfilter,"dum",LOCATION_EXTRA+
		LOCATION_DECK+LOCATION_HAND),s.spop)
end
function s.tfcon(e,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE) > 0
end
function s.tfop(e,tp)
	local c = e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR) and c:IsFaceup()
end
function s.descon(e,tp,eg)
	return eg:IsExists(s.cfilter,1,nil,tp) and e:GetHandler():IsComplexType(TYPE_SPELL+TYPE_CONTINUOUS)
end
function s.desop(e,tp)
	local c = rscf.GetSelf(e)
	if not c then return end
	local res = rscf.spfilter2()(c,e,tp)
	local op = rshint.SelectOption(tp,true,"des",res,"sp")
	if op == 1 then
		Duel.Destroy(c,REASON_EFFECT)
	else
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.reg(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spfilter(c,e,tp)
	return (c:IsCode(10133001) or c:IsHasEffect(10133009)) and rscf.spfilter2()(c,e,tp)
end
function s.xfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsCode(10133001) and c:IsFaceup()
end
function s.spop(e,tp)
	local c = rscf.GetSelf(e)
	if rsop.SelectOperate("sp",tp,s.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,{},e,tp) <= 0 or not c or not c:IsCanOverlay() or c:IsImmuneToEffect(e) then return end
	rsop.SelectExPara({id,2},true)
	local og,tc = rsop.SelectCards("self",tp,s.xfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if tc then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end