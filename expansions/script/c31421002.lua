local m=31421002
local cm=_G["c"..m]
cm.name="弹幕少女『星尘幻想』"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,cm.filter,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.seqcost)
	e1:SetTarget(cm.seqtg)
	e1:SetOperation(cm.seqop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	e2:SetValue(cm.spval)
	c:RegisterEffect(e2)
end
cm.list={31421001,31421002,31421003,31421004,31421005,31421006,31421007,31421008}
function cm.filter(c)
	return c:IsCode(table.unpack(cm.list))
end
function cm.spfilter(c)
	local seq=c:GetSequence()
	return seq<5 and c:IsAbleToGraveAsCost() and Duel.GetFieldCard(c:GetControler(),LOCATION_MZONE,seq)==nil
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),LOCATION_SZONE,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_SZONE,0,1,1,nil)
	e:SetLabel(1<<(g:GetFirst():GetSequence()))
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.spval(e,c)
	return 0,e:GetLabel()
end
function cm.seqcfilter(c,g)
	return g:IsContains(c) and c:IsAbleToGraveAsCost() and c:IsPosition(POS_FACEUP)
end
function cm.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.seqcfilter,tp,LOCATION_SZONE,0,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(cm.seqcfilter,tp,LOCATION_SZONE,0,nil,cg)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.seqfilter(c,seq)
	local cseq=c:GetSequence()
	local d=math.abs(4-seq-cseq)
	return (d==0) or (d==1 and c:IsType(TYPE_MONSTER)) or (cseq==5 and math.abs(seq-3)<=1) or (cseq==6 and math.abs(seq-1)<=1)
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	if c:GetSequence()~=seq then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(cm.seqfilter,nil,c:GetSequence())
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_RULE)
	end
end