--GA-04 Amarillo Viridian
--Scripted by:XGlitchy30
local id=33720036
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--destroy and equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	local e3x=e3:Clone()
	e3x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3x)
	local e3y=e3:Clone()
	e3y:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3y)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetTarget(s.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		s.ssloc={0,0}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
		ge2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ge2:SetTargetRange(1,1)
		ge2:SetTarget(s.limit)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsCode,nil,id)
	if #g>0 then
		for tc in aux.Next(g) do
			local loc=tc:GetSummonLocation()
			if s.ssloc[tc:GetSummonPlayer()+1]&loc>0 then
				loc=loc&~(s.ssloc[tc:GetSummonPlayer()+1]&loc)
			end
			if loc>0 then
				s.ssloc[tc:GetSummonPlayer()+1]=s.ssloc[tc:GetSummonPlayer()+1]|loc
			end
		end
	end
end
--
function s.limit(e,c,sp)
	if s.ssloc[sp+1]==0 then return false end
	return c:IsCode(id) and c:IsLocation(s.ssloc[sp+1])
end
--
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end
--
function s.desfilter(c)
	return c:GetSequence()<5
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,5,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCode(id+1,id+2,id+3,id+4,id+5) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.eqcheck(c,codes)
	return c:IsCode(table.unpack(codes))
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_SZONE,0,nil)
	if Duel.Destroy(sg,REASON_EFFECT)>0 and e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<=0 then return end
		local eq=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
		if ft>#eq then ft=#eq end
		if ft==0 then return end
		local equipped=Group.CreateGroup()
		equipped:KeepAlive()
		for i=1,ft do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(69933858,1))
			local ec=eq:FilterSelect(tp,aux.NecroValleyFilter(),1,1,nil):GetFirst()
			if ec then
				eq:RemoveCard(ec)
				local cg=eq:Filter(s.eqcheck,ec,{ec:GetCode()})
				if #cg>0 then
					eq:Sub(cg)
				end
				if Duel.Equip(tp,ec,e:GetHandler(),true,true) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(s.eqlimit)
					e1:SetLabelObject(e:GetHandler())
					ec:RegisterEffect(e1)
					equipped:AddCard(ec)
				end
			end
		end
		Duel.EquipComplete()
		if #equipped<5 then
			Duel.SendtoHand(equipped,nil,REASON_EFFECT)
		end
		equipped:DeleteGroup()
	end	
end
--
function s.tgtg(e,c)
	return c:GetSequence()<5
end