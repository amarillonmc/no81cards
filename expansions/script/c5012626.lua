--山缪·李德·麦奎恩·马瑟斯
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	aux.AddCodeList(c,5012604)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	--抽卡效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.drawtg)
	e3:SetOperation(s.drawop)
	c:RegisterEffect(e3)
	
	--免疫效果
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+1)
	e4:SetCondition(s.discon)
	e4:SetTarget(s.immtg)
	e4:SetOperation(s.immop)
	c:RegisterEffect(e4)
	
	--破坏对方怪兽
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+2)
	e5:SetCondition(s.discon)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
	
	--随机丢弃
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,2))
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id+3)
	e6:SetCondition(s.discon)
	e6:SetTarget(s.distg)
	e6:SetOperation(s.disop)
	c:RegisterEffect(e6)
	
	--draw when sent to grave
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	--e7:SetCategory(CATEGORY_DRAW+REASON_DISCARD)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetTarget(s.drtg)
	e7:SetOperation(s.drop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_TO_HAND)
	e8:SetCondition(s.drcon)
	c:RegisterEffect(e8)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.IsExistingMatchingCard(c,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	  --if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	  Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)  
	--Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	--Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=e:GetActivateLocation()
	if not c:IsLocation(loc) then return end
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)~=0 then
		--Duel.Draw(tp,1,REASON_EFFECT)
		--Duel.Draw(1-tp,1,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		--Duel.BreakEffect()
		--Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		--Duel.ShuffleHand(1-tp)
		--Duel.BreakEffect()
		--Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_EXTRA)
end
function s.tgcfilter(c)
	return c.MoJin==true and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function s.fselect(g,tp,mc)
	if mc:IsLocation(LOCATION_EXTRA) then return Duel.GetLocationCountFromEx(tp,tp,g,mc)>0 end
	return Duel.GetMZoneCount(tp,g,tp)>0 
end
function s.spcon(e,c)
	if c==nil then return true end
	if c:IsFacedown() and c:IsLocation(LOCATION_EXTRA) then return end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.tgcfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,c)
	return g:CheckSubGroup(s.fselect,4,4,tp,c)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.tgcfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,s.fselect,true,4,4,tp,c)
	if not sg then return false end
	sg:KeepAlive()
	e:SetLabelObject(sg)
	return true
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

--抽卡效果
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--免疫效果
function s.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function s.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local egg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		egg:AddCard(te:GetHandler())
	end
	if #egg==0 then return end
	egg:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	e1:SetLabelObject(egg)
	e1:SetReset(RESET_EVENT+RESET_CHAIN)
	c:RegisterEffect(e1)
end

--破坏对方怪兽
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

--随机丢弃
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>1 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,LOCATION_HAND)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if hg:GetCount()>1 then
		local sg=hg:RandomSelect(tp,2)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end

function s.efilter(e,re)
	local g=e:GetLabelObject()
	return g:IsContains(re:GetHandler())
end