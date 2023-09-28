local m=53753006
local cm=_G["c"..m]
cm.name="尖刺毒流晕眩 达娜·梅里达"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.MultiDual(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.sumcon)
	e1:SetOperation(cm.sumop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(SNNM.DualState)
	e2:SetTarget(cm.tg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,5))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.setcon)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsAbleToDeckAsCost()
end
function cm.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 and mi<2 then return false end
	local tp=c:GetControler()
	local ct=Duel.GetMatchingGroupCount(cm.cfilter,tp,LOCATION_REMOVED,0,nil)
	return ma>0 and ct>0 and ((ct>=mi and (ft>0 or Duel.CheckTribute(c,1))) or (ct<mi and Duel.CheckTribute(c,mi-ct)))
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local tp=c:GetControler()
	local res=false
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	while mi>0 do
		local mg1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_REMOVED,0,sg1)
		local mg2=Group.__sub(Duel.GetTributeGroup(c),sg2)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 and not sg2:IsExists(Card.IsControler,1,nil,tp) then mg2=mg2:Filter(Card.IsControler,nil,tp) end
		local mg=Group.__add(mg1,mg2)
		if res then Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1)) else
			mg=mg1:Clone()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		end
		res=true
		local mc=mg:Select(tp,1,1,nil):GetFirst()
		if mc:IsLocation(LOCATION_REMOVED) then sg1:AddCard(mc) else sg2:AddCard(mc) end
		mi=mi-1
	end
	c:SetMaterial(Group.__add(sg1,sg2))
	if #sg1>0 then Duel.SendtoDeck(sg1,nil,2,REASON_SUMMON+REASON_MATERIAL) end
	if #sg2>0 then Duel.Release(sg2,REASON_SUMMON+REASON_MATERIAL) end
end
function cm.dfilter(c,tp,tc)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,Group.FromCards(c,tc))
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_HAND,0,1,nil,tp,c)
	local b2=Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,SNNM.multi_summon_count(Group.FromCards(c)),nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,4)
		opval[off-1]=3
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.DiscardHand(tp,cm.dfilter,1,1,REASON_COST+REASON_DISCARD,nil,tp,c)
		e:SetCategory(CATEGORY_SUMMON)
		e:SetOperation(cm.op1)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetOperation(cm.op2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	elseif opval[op]==3 then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(cm.op3)
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,SNNM.multi_summon_count(Group.FromCards(c)),1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler()):GetFirst()
	if tc then Duel.Summon(tp,tc,true,nil) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=SNNM.multi_summon_count(Group.FromCards(e:GetHandler()))
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ct,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function cm.setfilter(c)
	return aux.IsTypeInText(c,TYPE_DUAL) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then Duel.SSet(tp,g:GetFirst()) end
end
