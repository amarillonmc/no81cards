--织巢之虚 示指护父
local s,id=GetID()
local CARD_RYOSHU=33310451
local CARD_ORACLE_TERMINAL=33310480
local CARD_COMMAND_TARGET=33310489
s.VHisc_WEAVENEST=true
s.VHisc_SHIZHI=true

function s.initial_effect(c)
	--连接召唤
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	c:EnableReviveLimit()

	--①：特殊召唤成功时，从卡组·墓地装备「神谕终端 双蛇杖」
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)

	--②：随机使对方1只怪兽也当作「指令对象」使用，攻击力下降2000
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.namecon)
	e2:SetTarget(s.nametg)
	e2:SetOperation(s.nameop)
	c:RegisterEffect(e2)

	--③：那些怪兽效果的发动不会被无效化
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(s.grcon)
	e4:SetValue(s.chainfilter)
	c:RegisterEffect(e4)

	--③：那些怪兽发动的效果不会被无效化
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e5)
end

--连接素材：怪兽2只以上，其中包含「织巢」或「示指」怪兽
function s.matfilter(c)
	return c.VHisc_WEAVENEST or c.VHisc_SHIZHI
end

function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(s.matfilter,1,nil)
end

--①：可以装备的「神谕终端 双蛇杖」
function s.eqfilter(c,tp)
	return c:IsCode(CARD_ORACLE_TERMINAL) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc or not Duel.Equip(tp,tc,c,true) then return end

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.eqlimit)
	e1:SetLabelObject(c)
	tc:RegisterEffect(e1)
end

function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end

--②：自己·对方的主要阶段
function s.namecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function s.randomfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function s.nametg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.randomfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,1-tp,LOCATION_MZONE)
end

function s.nameop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.randomfilter,tp,0,LOCATION_MZONE,nil)
	if #g==0 then return end

	local tc=g:RandomSelect(tp,1):GetFirst()
	if not tc then return end

	--卡名也当作「指令对象」使用
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(CARD_COMMAND_TARGET)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	--攻击力下降2000
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-2000)
	tc:RegisterEffect(e2)
end

--③：避免墓地的多张同名卡重复赋予效果
function s.destroyedfilter(c,fid)
	return c:IsCode(id) and c:IsReason(REASON_DESTROY) and c:GetFieldID()<fid
end

function s.grcon(e)
	local c=e:GetHandler()
	if not c:IsReason(REASON_DESTROY) then return false end
	return not Duel.IsExistingMatchingCard(s.destroyedfilter,c:GetControler(),LOCATION_GRAVE,0,1,c,c:GetFieldID())
end

function s.grtg(e,c)
	return c:IsFaceup() and c:IsCode(CARD_RYOSHU) and s.flag(c)
end
function s.flag(c)
	c:RegisterFlagEffect(33310451,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	return true
end
--保护「良秀」在怪兽区域发动的效果
function s.chainfilter(e,ct)
	local te,tp,loc,code=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,
		CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CODE)
	return te and tp==e:GetHandlerPlayer() and loc==LOCATION_MZONE and code==CARD_RYOSHU
end