--化尘教外门弟子
local s,id,o=GetID()
local CodeList=1202015	--化尘诀卡号
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
	--again
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(s.retg)
	e3:SetOperation(s.reop)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return ((c:IsSetCard(0x9240) and c:IsType(TYPE_MONSTER)) or c:IsCode(CodeList))
		and c:IsReleasable(REASON_MATERIAL)
end
function s.sumcon(e,c,minc)
	if c==nil then return true end
	if c:IsLevelBelow(5) then return false end
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

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return e:GetHandler():GetFlagEffect(id)==0 and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and rc:IsCode(CodeList) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetHandler():GetFlagEffect(id)==0 and Duel.SelectEffectYesNo(tp,rc,aux.Stringid(id,2)) then
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end

function s.refilter(c)
	return (c:IsSetCard(0x9240) or c:IsCode(CodeList2) or aux.IsCodeListed(c,CodeList2)) 
		and c:IsAbleToHand()
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)<=2 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.refilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	--Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)<=2 
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.refilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.refilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end