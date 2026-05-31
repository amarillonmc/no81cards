--No.29 亚斯塔禄
--白龟是🐖
local s,id=GetID()
function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	
	--① negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	--② equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.eqtg)
	e2:SetOperation(s.eqop)
	c:RegisterEffect(e2)
	
	--③ atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	
	--④ destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.desreptg)
	e5:SetValue(s.desrepval)
	e5:SetOperation(s.desrepop)
	c:RegisterEffect(e5)
end

aux.xyz_number[11210005]=29

-------------------------
--① negate
-------------------------
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and rc:GetOriginalType()&(TYPE_SPELL+TYPE_TRAP)~=0
		and Duel.IsChainNegatable(ev)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		
		--如果本体不在场 → 不能 overlay，魔陷正常送墓
		if not (c:IsRelateToEffect(e) and c:IsFaceup() and c:IsType(TYPE_XYZ)) then
			return
		end

		-- overlay
		if rc:IsCanOverlay() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			if rc:IsType(TYPE_SPELL) or rc:IsType(TYPE_TRAP) then
				rc:CancelToGrave() --避免进入墓地
			end
			Duel.Overlay(c,Group.FromCards(rc))
		end
	end
end

-------------------------
--② equip（修复：取除 → 送墓 → 再装备）
-------------------------
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_EFFECT)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--● 先取除，再由系统自动送去墓地（取除一定会进入墓地）
	if Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		local tc=g:GetFirst()
		
		--● tc 已经正确进入墓地，不会再出现“装备后送墓”的错误逻辑
		if tc and tc:IsLocation(LOCATION_GRAVE)
			and not tc:IsHasEffect(EFFECT_NECRO_VALLEY)
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			
			--装备
			if Duel.Equip(tp,tc,c,false,true) then
				-- 正确的装备限制
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetValue(s.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)

				-- 防止装备被系统“当装备卡送墓”
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TO_GRAVE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetRange(LOCATION_SZONE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end

function s.eqlimit(e,c)
	return e:GetOwner()==c
end

-------------------------
--③ atk up
-------------------------
function s.atkval(e,c)
	return c:GetEquipCount()*1000
end

-------------------------
--④ destroy replace
-------------------------
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function s.repdfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsLocation(LOCATION_SZONE)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and c:IsAbleToGrave()
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp)
		and g:IsExists(s.repdfilter,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:FilterSelect(tp,s.repdfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function s.desrepval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Release(tg,REASON_EFFECT+REASON_REPLACE)
end
