--化尘教首席弟子-澹台仙
local s,id,o=GetID()
local CodeList=1202025	--聚尘决卡号
function s.initial_effect(c)
	aux.AddCodeList(c,CodeList)
	--本代码抄袭自「尖刺毒流晕眩 达娜·梅里达」（53753006）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(s.sumcon)
	e1:SetOperation(s.sumop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--level up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.lvcon)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(s.exsumop)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return ((c:IsSetCard(0x9240) and c:IsType(TYPE_MONSTER)) or c:IsCode(CodeList))
		and c:IsReleasable(REASON_MATERIAL)
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	if c:IsLevelBelow(6) then return false end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 and mi<2 then return false end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_DECK,0,nil)
	return ma>0 and ct>0 and ((ct>=mi and (ft>0 or Duel.CheckTribute(c,1))) or (ct<mi and Duel.CheckTribute(c,mi-ct)))
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local tp=c:GetControler()
	local res=false
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	while mi>0 do
		local mg1=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,sg1)
		local mg2=Group.__sub(Duel.GetTributeGroup(c),sg2)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and not sg2:IsExists(Card.IsControler,1,nil,tp) then 
			mg1:Clear()
			mg2=mg2:Filter(Card.IsControler,nil,tp) 
		end
		local mg=Group.__add(mg1,mg2)
		if not res and mg1:GetCount()>0 then
			mg=mg1:Clone()
			res=true
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mc=mg:Select(tp,1,1,nil):GetFirst()
		if mc:IsLocation(LOCATION_DECK) then sg1:AddCard(mc) else sg2:AddCard(mc) end
		mi=mi-1
	end
	c:SetMaterial(Group.__add(sg1,sg2))
	Duel.Release(Group.__add(sg1,sg2),REASON_SUMMON+REASON_MATERIAL)
	--if #sg1>0 then Duel.SendtoDeck(sg1,nil,2,REASON_SUMMON+REASON_MATERIAL) end
	--if #sg2>0 then Duel.Release(Group.__add(sg1,sg2),REASON_SUMMON+REASON_MATERIAL) end
end

function s.exsumop(e,tp,eg,ep,ev,re,r,rp)
	--normal summon/set
	local ct=1
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
	for _,te in ipairs(ce) do
		ct=math.max(ct,te:GetValue())
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(ct+1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x9240)
end

function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and Duel.GetFlagEffect(tp,id)==0
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	Duel.RegisterFlagEffect(tp,id,0,0,0)
	local c=e:GetHandler()
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsLevelAbove,nil,1)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetLabel(c:GetControler())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetLabel(tp)
	e2:SetOperation(s.hlvop)
	Duel.RegisterEffect(e2,tp)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetValue(1)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e3)
end
function s.hlvfilter(c,p)
	return c:IsLevelAbove(1) and c:IsControler(p)
end
function s.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	local hg=eg:Filter(s.hlvfilter,nil,p)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end