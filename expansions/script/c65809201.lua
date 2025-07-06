--资源获取·奴隶
--Global handlings
--代码引用：游戏王edopro/proc_unofficial.lua
UnofficialProc={}
PROC_STATS_CHANGED=false
function UnofficialProc.statsChanged()
	local function op5(e,tp,eg,ep,ev,re,r,rp)
		--ATK = 285, prev ATK = 284
		--LVL = 585, prev LVL = 584
		--DEF = 385, prev DEF = 384
		local g=Duel.GetMatchingGroup(nil,tp,0xff,0xff,nil)
		for tc in aux.Next(g) do
			if tc:GetFlagEffect(285)==0 and tc:GetFlagEffect(585)==0 then
				local atk=tc:GetAttack()
				local def=tc:GetDefense()
				if atk<0 then atk=0 end
				if def<0 then def=0 end
				tc:RegisterFlagEffect(285,0,0,1,atk)
				tc:RegisterFlagEffect(284,0,0,1,atk)
				tc:RegisterFlagEffect(385,0,0,1,def)
				tc:RegisterFlagEffect(384,0,0,1,def)
				local lv=tc:GetLevel()
				tc:RegisterFlagEffect(585,0,0,1,lv)
				tc:RegisterFlagEffect(584,0,0,1,lv)
			end
		end
	end
	local function atkcfilter(c)
		if c:GetFlagEffect(285)==0 then return false end
		return c:GetAttack()~=c:GetFlagEffectLabel(285)
	end
	local function defcfilter(c)
		if c:GetFlagEffect(385)==0 then return false end
		return c:GetDefense()~=c:GetFlagEffectLabel(385)
	end
	local function lvcfilter(c)
		if c:GetFlagEffect(585)==0 then return false end
		return c:GetLevel()~=c:GetFlagEffectLabel(585)
	end
	local function atkraiseeff(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(atkcfilter,tp,0x7f,0x7f,nil)
		local g1=Group.CreateGroup() --change atk
		local g2=Group.CreateGroup() --gain atk
		local g3=Group.CreateGroup() --lose atk
		local g4=Group.CreateGroup() --gain atk from original
		local g9=Group.CreateGroup() --lose atk from original

		local dg=Duel.GetMatchingGroup(defcfilter,tp,0x7f,0x7f,nil)
		local g5=Group.CreateGroup() --change def
		local g6=Group.CreateGroup() --gain def
		--local g7=Group.CreateGroup() --lose def
		--local g8=Group.CreateGroup() --gain def from original
		for tc in aux.Next(g) do
			local prevatk=0
			if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
			g1:AddCard(tc)
			if prevatk>tc:GetAttack() then
				g3:AddCard(tc)
			else
				g2:AddCard(tc)
				if prevatk<=tc:GetBaseAttack() and tc:GetAttack()>tc:GetBaseAttack() then
					g4:AddCard(tc)
				end
				if prevatk>=tc:GetBaseAttack() and tc:GetAttack()<tc:GetBaseAttack() then
					g9:AddCard(tc)
				end
			end
			tc:ResetFlagEffect(284)
			tc:ResetFlagEffect(285)
			if prevatk>0 then
				tc:RegisterFlagEffect(284,0,0,1,prevatk)
			else
				tc:RegisterFlagEffect(284,0,0,1,0)
			end
			if tc:GetAttack()>0 then
				tc:RegisterFlagEffect(285,0,0,1,tc:GetAttack())
			else
				tc:RegisterFlagEffect(285,0,0,1,0)
			end
		end

		for dc in aux.Next(dg) do
			local prevdef=0
			if dc:GetFlagEffect(385)>0 then prevdef=dc:GetFlagEffectLabel(385) end
			g5:AddCard(dc)
			if prevdef>dc:GetDefense() then
				--g7:AddCard(dc)
			else
				g6:AddCard(dc)
				if prevdef<=dc:GetBaseDefense() and dc:GetDefense()>dc:GetBaseDefense() then
					--g8:AddCard(dc)
				end
			end
			dc:ResetFlagEffect(384)
			dc:ResetFlagEffect(385)
			if prevdef>0 then
				dc:RegisterFlagEffect(384,0,0,1,prevdef)
			else
				dc:RegisterFlagEffect(384,0,0,1,0)
			end
			if dc:GetDefense()>0 then
				dc:RegisterFlagEffect(385,0,0,1,dc:GetDefense())
			else
				dc:RegisterFlagEffect(385,0,0,1,0)
			end
		end

		if #g1>0 then
			Duel.RaiseEvent(g1,511001265,re,REASON_EFFECT,rp,ep,0)
			Duel.RaiseEvent(g1,511001441,re,REASON_EFFECT,rp,ep,0)
		end
		if #g2>0 then
			Duel.RaiseEvent(g2,511000377,re,REASON_EFFECT,rp,ep,0)
			Duel.RaiseEvent(g2,511001762,re,REASON_EFFECT,rp,ep,0)
		end
		if #g3>0 then
			Duel.RaiseEvent(g3,511000883,re,REASON_EFFECT,rp,ep,0)
			Duel.RaiseEvent(g3,511009110,re,REASON_EFFECT,rp,ep,0)
		end
		if #g4>0 then
			Duel.RaiseEvent(g4,511002546,re,REASON_EFFECT,rp,ep,0)
		end
		if #g5>0 then
			Duel.RaiseEvent(g5,511009053,re,REASON_EFFECT,rp,ep,0)
			Duel.RaiseEvent(g5,511009565,re,REASON_EFFECT,rp,ep,0)
		end
		if #g9>0 then
			Duel.RaiseEvent(g9,511010103,re,REASON_EFFECT,rp,ep,0)
		end
		--Duel.RaiseEvent(g6,,re,REASON_EFFECT,rp,ep,0)

		local lvg=Duel.GetMatchingGroup(lvcfilter,tp,0x7f,0x7f,nil)
		if #lvg>0 then
			for lvc in lvaux.Next(g) do
				local prevlv=lvc:GetFlagEffectLabel(585)
				lvc:ResetFlagEffect(584)
				lvc:ResetFlagEffect(585)
				lvc:RegisterFlagEffect(584,0,0,1,prevlv)
				lvc:RegisterFlagEffect(585,0,0,1,lvc:GetLevel())
			end
			Duel.RaiseEvent(lvg,511002524,re,REASON_EFFECT,rp,ep,0)
		end

		Duel.RegisterFlagEffect(tp,285,RESET_CHAIN,0,1)
		Duel.RegisterFlagEffect(1-tp,285,RESET_CHAIN,0,1)
	end
	local function atkraiseadj(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetFlagEffect(tp,285)~=0 or Duel.GetFlagEffect(1-tp,285)~=0 then return end
		local g=Duel.GetMatchingGroup(atkcfilter,tp,0x7f,0x7f,nil)
		local g1=Group.CreateGroup() --change atk
		local g2=Group.CreateGroup() --gain atk
		local g3=Group.CreateGroup() --lose atk
		local g4=Group.CreateGroup() --gain atk from original
		local g9=Group.CreateGroup() --lose atk from original

		local dg=Duel.GetMatchingGroup(defcfilter,tp,0x7f,0x7f,nil)
		local g5=Group.CreateGroup() --change def
		--local g6=Group.CreateGroup() --gain def
		--local g7=Group.CreateGroup() --lose def
		--local g8=Group.CreateGroup() --gain def from original
		for tc in aux.Next(g) do
			local prevatk=0
			if tc:GetFlagEffect(285)>0 then prevatk=tc:GetFlagEffectLabel(285) end
			g1:AddCard(tc)
			if prevatk>tc:GetAttack() then
				g3:AddCard(tc)
			else
				g2:AddCard(tc)
				if prevatk<=tc:GetBaseAttack() and tc:GetAttack()>tc:GetBaseAttack() then
					g4:AddCard(tc)
				end
				if prevatk>=tc:GetBaseAttack() and tc:GetAttack()<tc:GetBaseAttack() then
					g9:AddCard(tc)
				end
			end
			tc:ResetFlagEffect(284)
			tc:ResetFlagEffect(285)
			if prevatk>0 then
				tc:RegisterFlagEffect(284,0,0,1,prevatk)
			else
				tc:RegisterFlagEffect(284,0,0,1,0)
			end
			if tc:GetAttack()>0 then
				tc:RegisterFlagEffect(285,0,0,1,tc:GetAttack())
			else
				tc:RegisterFlagEffect(285,0,0,1,0)
			end
		end

		for dc in aux.Next(dg) do
			local prevdef=0
			if dc:GetFlagEffect(385)>0 then prevdef=dc:GetFlagEffectLabel(385) end
			g5:AddCard(dc)
			if prevdef>dc:GetDefense() then
				--g7:AddCard(dc)
			else
				--g6:AddCard(dc)
				if prevdef<=dc:GetBaseDefense() and dc:GetDefense()>dc:GetBaseDefense() then
					--g8:AddCard(dc)
				end
			end
			dc:ResetFlagEffect(284)
			dc:ResetFlagEffect(285)
			if prevdef>0 then
				dc:RegisterFlagEffect(284,0,0,1,prevdef)
			else
				dc:RegisterFlagEffect(284,0,0,1,0)
			end
			if dc:GetAttack()>0 then
				dc:RegisterFlagEffect(285,0,0,1,dc:GetAttack())
			else
				dc:RegisterFlagEffect(285,0,0,1,0)
			end
		end

		if #g1>0 then
			Duel.RaiseEvent(g1,511001265,e,REASON_EFFECT,rp,ep,0)
		end
		if #g2>0 then
			Duel.RaiseEvent(g2,511001762,e,REASON_EFFECT,rp,ep,0)
		end
		if #g3>0 then
			Duel.RaiseEvent(g3,511009110,e,REASON_EFFECT,rp,ep,0)
		end
		if #g4>0 then
			Duel.RaiseEvent(g4,511002546,e,REASON_EFFECT,rp,ep,0)
		end
		if #g5>0 then
			Duel.RaiseEvent(g5,511009053,e,REASON_EFFECT,rp,ep,0)
		end
		if #g9>0 then
			Duel.RaiseEvent(g9,511010103,e,REASON_EFFECT,rp,ep,0)
		end
		local lvg=Duel.GetMatchingGroup(lvcfilter,tp,0x7f,0x7f,nil)
		if #lvg>0 then
			for lvc in lvaux.Next(g) do
				local prevlv=lvc:GetFlagEffectLabel(585)
				lvc:ResetFlagEffect(584)
				lvc:ResetFlagEffect(585)
				lvc:RegisterFlagEffect(584,0,0,1,prevlv)
				lvc:RegisterFlagEffect(585,0,0,1,lvc:GetLevel())
			end
			Duel.RaiseEvent(lvg,511002524,e,REASON_EFFECT,rp,ep,0)
		end
	end

	local e5=Effect.GlobalEffect()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetOperation(op5)
	Duel.RegisterEffect(e5,0)
	local atkeff=Effect.GlobalEffect()
	atkeff:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	atkeff:SetCode(EVENT_CHAIN_SOLVED)
	atkeff:SetOperation(atkraiseeff)
	Duel.RegisterEffect(atkeff,0)
	local atkadj=Effect.GlobalEffect()
	atkadj:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	atkadj:SetCode(EVENT_ADJUST)
	atkadj:SetOperation(atkraiseadj)
	Duel.RegisterEffect(atkadj,0)
end
if not PROC_STATS_CHANGED then
	PROC_STATS_CHANGED=true
	UnofficialProc.statsChanged()
end
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(511001265)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.drcon)
	e3:SetCost(s.cost)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(511009053)
	e4:SetCondition(s.drcon2)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) end)
	e5:SetTarget(s.rmtg)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Group.CreateGroup()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsAttackAbove(500) and not c:IsStatus(STATUS_BATTLE_DESTROYED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		if c:GetAttack()==0 then dg:AddCard(c) end
	end
	if #dg==0 then return end
	Duel.BreakEffect()
	Duel.Destroy(dg,REASON_EFFECT)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return false end
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:GetAttack()~=val and c:IsFaceup() and c:IsOnField()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.ResetFlagEffect(tp,id)
end
function s.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) then return false end
	local val=0
	if c:GetFlagEffect(384)>0 then val=c:GetFlagEffectLabel(384) end
	return c:GetDefense()~=val
end

function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if #g>0 then
		local sg=g:RandomSelect(p,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end