--干员-歌蕾蒂娅·精英化
local m=88802008
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.AddCodeList(c,88802004,88802022)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,88802006,c88802008.matfilter,2,2,true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88802008,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c88802008.destg)
	e1:SetOperation(c88802008.desop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(c88802008.seqtg)
	e2:SetOperation(c88802008.seqop)
	c:RegisterEffect(e2)
	
end
function c88802008.matfilter(c,fc)
	return aux.IsCodeListed(c,88802004)
end
function c88802008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and (tc:GetRank()<5 and not tc:GetRank()==0) or (tc:GetLevel()<5 and not tc:GetLevel()==0) end
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