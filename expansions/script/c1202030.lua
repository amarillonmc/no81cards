--化尘教长老
local s,id,o=GetID()
local CodeList=1202035	--万尘化土卡号
local CodeList2=1202000	--引力术卡号
function s.initial_effect(c)
	aux.AddCodeList(c,CodeList,CodeList2)
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
	--Cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(s.con)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)	
	--activate cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetCost(s.costchk)
	e3:SetTarget(s.costtg)
	e3:SetOperation(s.costop)
	c:RegisterEffect(e3)
	--return 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(s.retg)
	e4:SetOperation(s.reop)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		s.willreturn=Group.CreateGroup()
		s.willreturn:KeepAlive()
	end
end
function s.limfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9240)
end
function s.con(e)
	return Duel.IsExistingMatchingCard(s.limfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.cfilter(c)
	return ((c:IsSetCard(0x9240) and c:IsType(TYPE_MONSTER)) or c:IsCode(CodeList))
		and c:IsReleasable(REASON_MATERIAL)
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	if c:IsLevelBelow(7) then return false end
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

function s.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsDefensePos() and re:IsActiveType(TYPE_MONSTER)
end

function s.costchk(e,te_or_c,tp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,CodeList2)
	local g=Duel.GetDecktopGroup(tp,gc)
	return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==gc
end
function s.costtg(e,te,tp)
	if not te:IsActiveType(TYPE_MONSTER) then return false end
	if not te:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) then return false end
	if not s.con(e) then return false end
	local c=e:GetHandler()
	local p=c:GetControler()
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,CodeList2)
	return gc>0
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local gc=Duel.GetMatchingGroupCount(Card.IsCode,p,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,CodeList2)
	local g=Duel.GetDecktopGroup(tp,gc)
	if Duel.Remove(g,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local c=e:GetHandler()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		s.willreturn:Merge(og)
		if Duel.GetFlagEffect(tp,id+2)==0 then
			local ge1=Effect.CreateEffect(c)
			ge1:SetDescription(aux.Stringid(id,3))
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_PHASE+PHASE_END)
			ge1:SetReset(RESET_PHASE+PHASE_END)
			--ge1:SetLabelObject(s.willreturn)
			ge1:SetCountLimit(1)
			ge1:SetCondition(s.retcon)
			ge1:SetOperation(s.retop)
			Duel.RegisterEffect(ge1,p)
			Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

function s.retfilter(c)
	return c:GetFlagEffect(id+1)~=0
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	if s.willreturn:IsExists(s.retfilter,1,nil) then
		return true
	else
		s.willreturn:Clear()
		return false
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	if s.willreturn:IsExists(s.retfilter,1,nil) then
		local g=s.willreturn:Filter(s.retfilter,nil)
		Duel.SendtoDeck(g,nil,0,REASON_RULE)
	end
	s.willreturn:Clear()
	--for tc in aux.Next(g) do
	--	Duel.ReturnToField(tc)
	--end
end

function s.refilter(c,tc)
	return c==tc
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)<=2 and e:GetHandler():IsAbleToHand() end
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)<=2 and c:IsAbleToHand()
		and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.refilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end