local m=188875
local cm=_G["c"..m]
cm.name="星魅的刻时之剑-霏妮"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(function(e,se,sp,st)return se:IsHasType(EFFECT_TYPE_ACTIONS)end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return eg:IsExists(function(c)return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_MZONE)end,1,nil)end)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if not eg:IsExists(Card.IsControlerCanBeChanged,1,nil) then x=0 end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+x>0 and Duel.GetFlagEffect(tp,m)==0
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local b2=#g>0 and Duel.GetFlagEffect(tp,m+100)==0
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	Duel.RegisterFlagEffect(tp,m+sel*100,RESET_PHASE+PHASE_END,0,1)
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,sel+1))
	if sel==0 then
		Duel.SetTargetCard(eg)
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function cm.mvfilter(c,e)
	local x=Duel.GetLocationCount(1-c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)
	if not c:IsControlerCanBeChanged() then x=0 end
	return c:IsRelateToEffect(e) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,PLAYER_NONE,0)+x>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local c=e:GetHandler()
	if sel==0 then
		local g=eg:Filter(cm.mvfilter,nil,e)
		if #g==0 then return end
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		if #g>1 then tc=g:Select(tp,nil,1,1):GetFirst() end
		local loc=LOCATION_MZONE
		if not tc:IsControlerCanBeChanged() then loc=0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		if tc:IsControler(tp) then
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,loc,0xe000e0)
			local nseq=math.log(s,2)
			if nseq<16 then Duel.MoveSequence(tc,nseq) else Duel.GetControl(tc,1-tp,0,0,1<<(nseq-16)) end
		else
			local s=Duel.SelectDisableField(tp,1,loc,LOCATION_MZONE,0xe000e0)
			local nseq=math.log(s,2)
			if nseq<16 then Duel.GetControl(tc,tp,0,0,1<<nseq) else Duel.MoveSequence(tc,nseq-16) end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,m+200)==0 end
	Duel.RegisterFlagEffect(tp,m+200,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(function(c,e,tp)return c:IsCode(188874) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)end),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
