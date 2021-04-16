--噬界兽LV7-轰鸣形态
local m=14000204
local cm=_G["c"..m]
cm.named_with_Worlde=1
function cm.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(cm.spcon)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.eqtg)
	e3:SetOperation(cm.eqop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(cm.distg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.discon)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
	if not cm.global_flag then
		cm.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.gyeqcon)
	e6:SetTarget(cm.gyeqtg)
	e6:SetOperation(cm.gyeqop)
	c:RegisterEffect(e6)
end
cm.lvup={14000203,14000205}
cm.lvdn={14000200,14000201,14000202,14000203}
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(14000203) then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),14000203,0,0,0)
		end
	end
end
function cm.splimit(e,se,sp,st)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,14000203)>0
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	local tg=fg:Filter(Card.IsAbleToGraveAsCost,nil)
	if chk==0 then return #fg==#tg and #tg>1 end
	Duel.SendtoGrave(tg,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(14000205) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and re:GetHandler()~=c and c:GetFlagEffect(m)<3 and not c:IsStatus(STATUS_BATTLE_DESTROYED) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,m)
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,0,0)
		local ct1,ct2={},{}
		local ctg=Group.CreateGroup()
		for i=9,1,-1 do
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=i then
				table.insert(ct1,i)
			end
			if Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=i then
				table.insert(ct2,i)
			end
		end
		if #ct1~=0 or #ct2~=0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local ac1=Duel.AnnounceNumber(tp,table.unpack(ct1))
			Duel.ConfirmDecktop(tp,ac1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local ac2=Duel.AnnounceNumber(tp,table.unpack(ct2))
			Duel.ConfirmDecktop(1-tp,ac2)
			ctg:Merge(Duel.GetDecktopGroup(tp,ac1))
			ctg:Merge(Duel.GetDecktopGroup(1-tp,ac2))
		end
		local tc=ctg:Select(tp,1,1,nil):GetFirst()
		if Duel.Equip(tp,tc,c,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
		end
		ctg:RemoveCard(tc)
		if #ctg>0 then
			Duel.SendtoGrave(ctg,REASON_EFFECT)
		end
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.disfilter(c)
	return c:IsFaceup()
end
function cm.distg(e,c)
	if c:IsFacedown() then return false end
	local g=e:GetHandler():GetEquipGroup():Filter(cm.disfilter,nil)
	local code=c:GetCode()
	local res=g:IsExists(Card.IsCode,1,nil,code)
	return res
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(cm.disfilter,nil)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	return g:IsExists(Card.IsCode,1,nil,code)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.gyeqfilter(c,tp)
	return c:IsControlerCanBeChanged() or c:IsControler(tp)
end
function cm.gyeqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(aux.NecroValleyFilter(cm.gyeqfilter),1,nil,tp)
end
function cm.gyeqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function cm.gyeqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,m)
		local tc=eg:FilterSelect(tp,cm.gyeqfilter,1,1,nil,tp):GetFirst()
		if Duel.Equip(tp,tc,c,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			tc:RegisterEffect(e1)
		end
	end
end