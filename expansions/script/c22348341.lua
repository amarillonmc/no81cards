--「 免 费 拥 抱 」
local m=22348341
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c22348341.target)
	e1:SetOperation(c22348341.activate)
	c:RegisterEffect(e1)
end
function c22348341.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (Duel.GetFlagEffect(tp,22348341)~=0 or Duel.GetFlagEffect(tp,22348342)<1)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22348342,0,TYPES_TOKEN_MONSTER,800,2000,4,RACE_FIEND,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22348341.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,22348342,0,TYPES_TOKEN_MONSTER,800,2000,4,RACE_FIEND,ATTRIBUTE_EARTH) then
	local token=Duel.CreateToken(tp,22348342)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetOperation(c22348341.desop)
		token:RegisterEffect(e1,true)
		Duel.RegisterFlagEffect(tp,22348341,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,22348342,RESET_PHASE+PHASE_END,0,2)
	end
end
function c22348341.setfilter(c)
	return c:IsCode(22348341) and c:IsSSetable()
end
function c22348341.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetPreviousControler()
	if c:IsPreviousControler(tp) and rp==1-tp and Duel.IsExistingMatchingCard(c22348341.setfilter,tp,LOCATION_GRAVE,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348341.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		local gc=g:GetFirst()
		if gc and Duel.SSet(tp,gc)~=0 then
			local cg=gc:GetColumnGroup()
			cg:AddCard(gc)
			if #cg~=0 and Duel.SelectYesNo(tp,aux.Stringid(22348341,0)) then
			Duel.Destroy(cg,REASON_EFFECT)
			end
		end
	end
	e:Reset()
end
