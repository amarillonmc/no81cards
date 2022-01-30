-- 超纠结 / Iper Ossessione
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s.listed_names={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TO_GRAVE)
		ge2:SetCondition(s.regcon2)
		ge2:SetOperation(s.regop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge3:SetCode(EVENT_CHAIN_SOLVED)
		ge3:SetLabelObject(ge2)
		ge3:SetCondition(s.cscon)
		ge3:SetOperation(s.regop)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return #s.listed_names>0 and (not re or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function s.checkname(c,e,tp)
	if c:GetType()&TYPE_MONSTER==0 or not c:IsLocation(LOCATION_GRAVE) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsCanBeSpecialSummoned(e,7250,tp,false,false) then return false end
	for _,prev in ipairs({c:GetCode()}) do
		for _,name in ipairs(s.listed_names) do
			if prev==name then
				return true
			end
		end
	end
	return false
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g
	if e:GetLabelObject() then
		Duel.ResetFlagEffect(tp,id)
		g=e:GetLabelObject():GetLabelObject()
	else
		g=eg:Filter(s.checkname,nil,e,tp)
	end
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,7250,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return #s.listed_names>0 and Duel.GetFlagEffect(tp,id)==0 and re and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.cscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if #s.listed_names==0 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(id,1))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e2:SetTargetRange(1,0)
			e2:SetTarget(s.splimit)
			Duel.RegisterEffect(e2,tp)
		end
		local codes={tc:GetCode()}
		for _,name in ipairs(codes) do
			local chk=true
			if #s.listed_names>0 then
				for _,checkn in ipairs(s.listed_names) do
					if name==checkn then
						chk=false
						break
					end
				end
			end
			if chk then
				table.insert(s.listed_names,name)
			end
		end
	end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if sumtype==(SUMMON_TYPE_SPECIAL+7250) then return false end
	for _,prev in ipairs({c:GetCode()}) do
		for _,name in ipairs(s.listed_names) do
			if prev==name then
				return false
			end
		end
	end
	return true
end