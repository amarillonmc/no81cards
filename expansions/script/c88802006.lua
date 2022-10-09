--干员-歌蕾蒂娅
local m=88802006
local cm=_G["c"..m]

function c88802006.initial_effect(c)
	aux.AddCodeList(c,88802004,88802022)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88802007)
	e1:SetTarget(cm.destg2)
	e1:SetOperation(cm.desop2)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,88802006)
	e2:SetTarget(c88802006.seqtg)
	e2:SetOperation(c88802006.seqop)
	c:RegisterEffect(e2) 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88802006,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c88802006.destg)
	e1:SetOperation(c88802006.desop)
	c:RegisterEffect(e1)
end
function c88802006.seqfilter(c,g)
  return g:IsContains(c) and c:IsType(TYPE_MONSTER)
end
function c88802006.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local cg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
  Group.AddCard(cg,e:GetHandler())
  if chkc then return chkc:IsOnField() and c88802006.seqfilter(chkc,cg) end
  if chk==0 then return Duel.IsExistingTarget(c88802006.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c88802006.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
end
function c88802006.seqop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tc:GetControler(),LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
  if tc:GetControler()==e:GetHandler():GetControler() then
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
  else
	local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	local nseq=math.log(bit.rshift(s,16),2)
	Duel.MoveSequence(tc,nseq)
  end
end
function c88802006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and (tc:GetRank()<5 and tc:GetRank()~=0) or (tc:GetLevel()<5 and tc:GetLevel()~=0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c88802006.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c88802006.desfilter(c,tp)
	return  aux.IsCodeListed(c,88802004) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0 
end
function c88802006.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c88802006.desfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)  and Duel.IsExistingTarget(c88802006.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c88802006.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c88802006.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end