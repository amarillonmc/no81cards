--梦幻叙事记「武者」
function c10200122.initial_effect(c)
	-- 召唤装备
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10200122,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c10200122.tg1)
	e1:SetOperation(c10200122.op1)
	c:RegisterEffect(e1)
	-- 位置移动和投枪
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200122,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c10200122.con2)
	e2:SetCost(c10200122.cost2)
	e2:SetTarget(c10200122.tg2)
	e2:SetOperation(c10200122.op2)
	c:RegisterEffect(e2)
	-- 赋予效果1
	local e3a=Effect.CreateEffect(c)
	e3a:SetDescription(aux.Stringid(10200122,3))
	e3a:SetCategory(CATEGORY_DESTROY)
	e3a:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3a:SetCode(EVENT_CUSTOM+10200122)
	e3a:SetRange(LOCATION_SZONE)
	e3a:SetProperty(EFFECT_FLAG_DELAY)
	e3a:SetCondition(c10200122.grantcon1)
	e3a:SetTarget(c10200122.granttg1)
	e3a:SetOperation(c10200122.grantop1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e3:SetTarget(c10200122.eqchk)
	e3:SetLabelObject(e3a)
	c:RegisterEffect(e3)
	if not c10200122.global_check then
		c10200122.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(c10200122.movecheckop)
		Duel.RegisterEffect(ge1,0)
	end
	-- 赋予效果2
	local e4a=Effect.CreateEffect(c)
	e4a:SetDescription(aux.Stringid(10200122,4))
	e4a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4a:SetCode(EVENT_MOVE)
	e4a:SetProperty(EFFECT_FLAG_DELAY)
	e4a:SetCondition(c10200122.grantcon2)
	e4a:SetTarget(c10200122.granttg2)
	e4a:SetOperation(c10200122.grantop2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e4:SetTarget(c10200122.eqchk)
	e4:SetLabelObject(e4a)
	c:RegisterEffect(e4)
	-- 与枪同亡
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c10200122.con4)
	c:RegisterEffect(e5)
end
-- 1
function c10200122.eqfilter(c,ec)
	return c:IsCode(10200123) and c:CheckEquipTarget(ec)
end
function c10200122.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 
		and Duel.IsExistingMatchingCard(c10200122.eqfilter,tp,LOCATION_DECK,0,1,nil,c) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200122.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if Duel.GetOperatedGroup():GetCount()>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eq=Duel.SelectMatchingCard(tp,c10200122.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
		if #eq>0 then
			Duel.Equip(tp,eq:GetFirst(),c)
		end
	end
end
-- 2
function c10200122.cfilter(c)
	return c:IsFaceup() and c:IsCode(10200123)
end
function c10200122.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10200122.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10200122.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c10200122.checkemptycolumn(tp,seq)
	if seq>4 then return false end
	local sc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
	if sc then return false end
	local oppseq=4-seq
	local omc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,oppseq)
	if omc and omc:GetControler()==tp then return false end
	local osc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,oppseq)
	if osc and osc:GetControler()==tp then return false end
	if seq==1 then
		local emc=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
		if emc then return false end
		local oemc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
		if oemc and oemc:GetControler()==tp then return false end
	elseif seq==3 then
		local emc=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
		if emc then return false end
		local oemc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
		if oemc and oemc:GetControler()==tp then return false end
	end
	return true
end
function c10200122.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chk==0 then
		if seq>4 then return false end
		for i=0,4 do
			if i~=seq and Duel.CheckLocation(tp,LOCATION_MZONE,i) and c10200122.checkemptycolumn(tp,i) then
				return true
			end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200122.eqlimit(e,c)
	return c:IsCode(10200122)
end
function c10200122.eqfilter2(c,tp)
	return c:IsCode(10200123) and c:IsControler(tp)
end
function c10200122.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not c:IsLocation(LOCATION_MZONE) then return end
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	for i=0,4 do
		if i~=seq and Duel.CheckLocation(tp,LOCATION_MZONE,i) and c10200122.checkemptycolumn(tp,i) then
			flag=flag|(1<<i)
		end
	end
	if flag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0x1f~flag)
	local nseq=0
	for i=0,4 do
		if (zone&(1<<i))~=0 then
			nseq=i
			break
		end
	end
	Duel.MoveSequence(c,nseq)
	local eqg=c:GetEquipGroup():Filter(c10200122.eqfilter2,nil,tp)
	if #eqg==0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(10200122,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARD)
	local eq=eqg:Select(tp,1,1,nil):GetFirst()
	local curseq=c:GetSequence()
	if curseq>4 then return end
	local opp_same_seq=4-curseq
	local disable_flag=(1<<(opp_same_seq+24))|(1<<(5+24))|(1<<(6+24))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local dest_zone=Duel.SelectField(tp,1,0,LOCATION_SZONE,disable_flag)
	local dest_seq=0
	for i=0,4 do
		if (dest_zone&(1<<(i+24)))~=0 then
			dest_seq=i
			break
		end
	end
	local tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,dest_seq)
	if tc then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.BreakEffect()
	end
	local te1=Effect.CreateEffect(c)
	te1:SetType(EFFECT_TYPE_SINGLE)
	te1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	te1:SetReset(RESET_CHAIN)
	eq:RegisterEffect(te1)
	local te2=Effect.CreateEffect(c)
	te2:SetType(EFFECT_TYPE_SINGLE)
	te2:SetCode(EFFECT_EQUIP_LIMIT)
	te2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	te2:SetValue(c10200122.eqlimit)
	te2:SetReset(RESET_CHAIN)
	eq:RegisterEffect(te2)
	Duel.MoveToField(eq,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,1<<dest_seq)
	if eq:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		Duel.Equip(tp,eq,c)
	end
	if not eq:IsLocation(LOCATION_SZONE) then return end
	local cg=eq:GetColumnGroup()
	local desg=cg:Filter(c10200122.coldesfilter,eq)
	if #desg>0 then
		Duel.Destroy(desg,REASON_EFFECT)
	end
end
function c10200122.coldesfilter(c,eq)
	return c~=eq and not c:IsCode(10200123)
end
-- 3
function c10200122.eqchk(e,c)
	local ec=e:GetHandler()
	return c:GetEquipTarget()==ec
end
function c10200122.grantcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return false end
	if not c:IsLocation(LOCATION_SZONE) then return false end
	local ec=c:GetEquipTarget()
	if not ec then return false end
	local cg=c:GetColumnGroup()
	return cg:GetCount()>0
end
function c10200122.granttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200122.grantop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	if not ec then return end
	local owner=c:GetOwner()
	local ctp=c:GetControler()
	local curseq=c:GetSequence()
	local disable_flag=(1<<(5+8))|(1<<(6+8))
	Duel.Hint(HINT_SELECTMSG,owner,HINTMSG_TOZONE)
	local zone=Duel.SelectField(owner,1,LOCATION_SZONE,0,disable_flag)
	local seq=0
	for i=0,4 do
		if (zone&(1<<(i+8)))~=0 then
			seq=i
			break
		end
	end
	local tc=Duel.GetFieldCard(owner,LOCATION_SZONE,seq)
	if tc and tc~=c then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.BreakEffect()
	end
	if not c:IsRelateToEffect(e) then return end
	local te1=Effect.CreateEffect(ec)
	te1:SetType(EFFECT_TYPE_SINGLE)
	te1:SetCode(EFFECT_CANNOT_TO_GRAVE)
	te1:SetReset(RESET_CHAIN)
	c:RegisterEffect(te1)
	local te2=Effect.CreateEffect(ec)
	te2:SetType(EFFECT_TYPE_SINGLE)
	te2:SetCode(EFFECT_EQUIP_LIMIT)
	te2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	te2:SetValue(c10200122.eqlimit)
	te2:SetReset(RESET_CHAIN)
	c:RegisterEffect(te2)
	if ctp==owner and c:IsLocation(LOCATION_SZONE) and curseq<=4 then
		if curseq~=seq then
			Duel.MoveSequence(c,seq)
		end
	else
		Duel.MoveToField(c,owner,owner,LOCATION_SZONE,POS_FACEUP,true,1<<seq)
	end
	if c:IsLocation(LOCATION_SZONE) and ec:IsFaceup() and ec:IsLocation(LOCATION_MZONE) then
		Duel.Equip(owner,c,ec)
	end
end
--
function c10200122.grantcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return false end
	if not c:IsPreviousLocation(LOCATION_SZONE) then return false end
	return c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler()
end
function c10200122.granttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c10200122.grantop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
-- 4
function c10200122.filter4(c)
	return c:IsFaceup() and c:IsCode(10200123)
end
function c10200122.con4(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and not e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
		and not Duel.IsExistingMatchingCard(c10200122.filter4,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
--
function c10200122.movecheckfilter(c,eg)
	if not c:IsCode(10200123) then return false end
	if not c:IsLocation(LOCATION_SZONE) then return false end
	local ec=c:GetEquipTarget()
	if not ec then return false end
	if not ec:IsCode(10200122) then return false end
	if not eg:IsContains(ec) then return false end
	if not ec:IsLocation(LOCATION_MZONE) then return false end
	if not ec:IsPreviousLocation(LOCATION_MZONE) then return false end
	if ec:GetPreviousSequence()==ec:GetSequence() and ec:GetPreviousControler()==ec:GetControler() then 
		return false
	end
	return true
end
function c10200122.movecheckop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10200122.movecheckfilter,0,LOCATION_SZONE,LOCATION_SZONE,nil,eg)
	if #g==0 then return end
	g=g:Clone()
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabelObject(g)
	e1:SetOperation(c10200122.moveregop)
	Duel.RegisterEffect(e1,tp)
end
function c10200122.moveregop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.RaiseEvent(g,EVENT_CUSTOM+10200122,e,0,0,0,0)
	g:DeleteGroup()
	e:Reset()
end
