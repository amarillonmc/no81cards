--底噪石窟-血鞘守心
local s,id,o=GetID()
local SET_BOTTOMNOISE=0x5d71
local CARD_BOTTOMNOISE_CAVERN=21401270
local CARD_EVIL_LIQUID=21401281
local FUSION_MATERIAL_COUNT=3

function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--special summon procedure
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_FUSION)
	e0:SetCondition(s.fuscon)
	e0:SetOperation(s.fusop)
	c:RegisterEffect(e0)

	--① 「底噪石窟」的效果发动的场合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.descon1)
	e1:SetTarget(s.destg1)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	--① 「底噪石窟」进行战斗的攻击宣言时
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.descon2)
	e2:SetTarget(s.destg2)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)


	--② search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

--self Special Summon procedure
function s.matfilter(c)
	return c:IsFaceup()
		and c:IsCode(CARD_BOTTOMNOISE_CAVERN)
		and c:IsAbleToGraveAsCost()
end

function s.matgroup(tp)
	local oloc=0
	if Duel.IsPlayerAffectedByEffect(tp,CARD_EVIL_LIQUID) then
		oloc=LOCATION_ONFIELD
	end
	return Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_ONFIELD,oloc,nil)
end

function s.fuscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=s.matgroup(tp)
	if g:GetCount()<FUSION_MATERIAL_COUNT then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then return true end
	return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp,c)
	local ct=FUSION_MATERIAL_COUNT
	local g=s.matgroup(tp)
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
		sg:Merge(g1)
		g:Sub(g1)
		if ct-1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=g:Select(tp,ct-1,ct-1,nil)
			sg:Merge(g2)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sg=g:Select(tp,ct,ct,nil)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end

--① effect activation trigger
function s.descon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc and rc:IsOnField()
		and rc:IsCode(CARD_BOTTOMNOISE_CAVERN)
		and rc:IsDestructable()
end

function s.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then
		return rc and rc:IsOnField() and rc:IsDestructable()
	end
	e:SetLabelObject(rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end

--① attack declaration trigger
function s.desfilter(c)
	return c and c:IsFaceup()
		and c:IsCode(CARD_BOTTOMNOISE_CAVERN)
		and c:IsDestructable()
end

function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return s.desfilter(a) or s.desfilter(d)
end

function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if s.desfilter(a) then g:AddCard(a) end
	if s.desfilter(d) then g:AddCard(d) end
	if chk==0 then return g:GetCount()>0 end
	local tc=nil
	if g:GetCount()==1 then
		tc=g:GetFirst()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	e:SetLabelObject(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsOnField() and tc:IsDestructable() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--②
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function s.thfilter(c)
	return c:IsSetCard(SET_BOTTOMNOISE) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
