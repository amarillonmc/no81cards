--唤祐重器 武王征商簋
VHisc_HYZQ=VHisc_HYZQ or {}

-------------------Register Release effect------------------
function VHisc_HYZQ.rlef(ec,cid,efcate)
	local cs=_G["c"..cid]
	local e2=Effect.CreateEffect(ec,cid,efcate)
	e2:SetCategory(efcate)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetTarget(cs.rltg)
	e2:SetOperation(cs.rlop)
	ec:RegisterEffect(e2)
end


function VHisc_HYZQ.rlft(c)
	return c.VHisc_HYZQ and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_ONFIELD) and c:IsReleasable()))
end

-------------------SpecialSummon------------------
function VHisc_HYZQ.mck(tp,cid)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,cid,nil,TYPES_NORMAL_TRAP_MONSTER,1500,1500,4,RACE_ROCK,ATTRIBUTE_EARTH)
end
function VHisc_HYZQ.mop(e,tp,cid)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,cid,nil,TYPES_NORMAL_TRAP_MONSTER,1500,1500,4,RACE_ROCK,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end


-------------------------card effect------------------------------
local m=33201370
local cm=_G["c"..m]
if not cm then return end
function cm.initial_effect(c)
	VHisc_HYZQ.rlef(c,m,0x100000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.VHisc_HYZQ=true
cm.VHisc_CNTreasure=true

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(VHisc_HYZQ.rlft,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler()) and VHisc_HYZQ.mck(tp,m) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(p,VHisc_HYZQ.rlft,p,LOCATION_HAND+LOCATION_MZONE,0,1,2,nil)
	local ct=Duel.SendtoGrave(g,REASON_RELEASE)
	Duel.Draw(p,ct,REASON_EFFECT)
	Duel.BreakEffect()
	VHisc_HYZQ.mop(e,tp,m)
end

--Release effect
function cm.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function cm.rlop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
