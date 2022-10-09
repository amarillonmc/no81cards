--干员-歌蕾蒂娅·精英化
local m=88802008
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddCodeList(c,88802004,88802022)
	--code
	aux.EnableChangeCode(c,88802006,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,88802006,c88802008.matfilter,2,2,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c88802008.destg)
	e1:SetOperation(c88802008.desop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88802008,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,88802008)
	e2:SetTarget(c88802008.seqtg)
	e2:SetOperation(c88802008.seqop)
	c:RegisterEffect(e2)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(88802008,1))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,88802009)
	e2:SetTarget(c88802008.seqtg2)
	e2:SetOperation(c88802008.seqop2)
	c:RegisterEffect(e2) 
	
end
function c88802008.matfilter(c,fc)
	return aux.IsCodeListed(c,88802004)
end
function c88802008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and (tc:GetRank()<5 and tc:GetRank()~=0) or (tc:GetLevel()<5 and tc:GetLevel()~=0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c88802008.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
function c88802008.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c88802008.desfilter(c,tp,seq)
	local sseq=c:GetSequence()
	if c:IsControler(tp) then return sseq==5 and seq==3 or sseq==6 and seq==1 end
	if c:IsLocation(LOCATION_SZONE) then return sseq<5 and sseq==seq end
	if sseq<5 then return math.abs(sseq-seq)==1 or sseq==seq end
	if sseq>=5 then return sseq==5 and seq==1 or sseq==6 and seq==3 end
end
function c88802008.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	Duel.Hint(HINT_ZONE,tp,seq)
	if c:GetSequence()==seq and  c:IsRelateToEffect(e) then
		local t2=Duel.GetMatchingGroup(c88802008.desfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,tp,4-seq)
		Duel.HintSelection(t2)
		Duel.Destroy(t2,REASON_EFFECT)
	end
end

function c88802008.seqfilter(c,g)
  return g:IsContains(c) and c:IsType(TYPE_MONSTER)
end
function c88802008.seqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local cg=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
  Group.AddCard(cg,e:GetHandler())
  if chkc then return chkc:IsOnField() and c88802008.seqfilter(chkc,cg) end
  if chk==0 then return Duel.IsExistingTarget(c88802008.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
  local g=Duel.SelectTarget(tp,c88802008.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
end
function c88802008.seqop2(e,tp,eg,ep,ev,re,r,rp)
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