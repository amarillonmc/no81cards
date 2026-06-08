--DEchoes Flute - Over Sensor
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	DEchoes.AddCode(c,DEchoes.SET_DECHOES)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,s.xyzfilter,8,2,nil,nil,99)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(function(e,c) return DEchoes.FaceupDEchoes(c) end)
	e0:SetValue(function(e,c,rc) if rc==e:GetHandler() then return 8 else return c:GetLevel() end end)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.atkcon)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(function(e,tp) return Duel.IsMainPhase() or Duel.IsBattlePhase() end)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end
function s.xyzfilter(c)
	return c:IsRace(RACE_DRAGON) or DEchoes.IsDEchoesMonster(c)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	local maxc=math.floor(c:GetOverlayCount()/2)*2
	local opts={}
	for i=2,maxc,2 do
		table.insert(opts,i)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local ct=Duel.AnnounceNumber(tp,table.unpack(opts))
	c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
	e:SetLabel(math.floor(ct/2))
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_EXTRA,0,ct,nil)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_EXTRA,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,PLAYER_ALL,LOCATION_EXTRA)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then return end
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsDestructable,p,LOCATION_EXTRA,0,nil)
		if #g>=ct then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
			local sg=g:Select(p,ct,ct,nil)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function s.atkcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(DEchoes.IsDEchoesMonster,1,nil)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(DEchoes.IsKernelMonster,c:GetControler(),LOCATION_GRAVE,0,nil)*800
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.FromCards(c)
	local kg=Duel.GetMatchingGroup(aux.NecroValleyFilter(DEchoes.GraveKernel),tp,LOCATION_GRAVE,0,nil)
	if #kg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=kg:Select(tp,0,math.min(3,#kg),nil)
		g:Merge(sg)
	end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
