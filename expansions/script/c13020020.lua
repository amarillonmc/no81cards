--在水之泗
local cm, m, ofs = GetID()
local yr = 13020010
xpcall(function() dofile("expansions/script/c16670000.lua") end,function() dofile("script/c16670000.lua") end)--引用库
function cm.initial_effect(c)
	aux.AddCodeList(c, yr)
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
	local e1=xg.epp2(c,m,4,EVENT_EQUIP,EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY,QY_mx,nil,nil,cm.target,cm.operation,true)
	e1:SetCountLimit(1,m)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.descon)
	--e3:SetCost(cm.cost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	--
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(cm.atkcon)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(function (e,tp,eg,ep,ev,re,r,rp)
		local c2=e:GetHandler()
		local ec=c2:GetEquipGroup()
		if #ec==0 then
			e:SetLabel(0)
			return
		end
		local ct=ec:Filter(cm.cfilter2, nil,tp)
		local ot=#ct
		e:SetLabel(ot)
	end)
	c:RegisterEffect(e4)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_LEAVE_FIELD)
	e13:SetCountLimit(1,m+1)
	e13:SetLabelObject(e4)
	e13:SetCondition(cm.descon2)
	e13:SetTarget(cm.sptg)
	e13:SetOperation(cm.desop)
	c:RegisterEffect(e13)
end
function cm.filter(c)
	return c:IsCode(yr) and c:IsAbleToHand()
end
function cm.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function cm.atkval(e,c)
	local tc = e:GetHandler():GetBattleTarget()
	
	return math.max(tc:GetAttack(),tc:GetDefense())
end
function cm.filter1(c,ec,c2)
	return c:GetEquipTarget()==ec and c==c2
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	--local dg=eg:Filter(cm.filter1,nil,tc,c)
	local kx,zzx,sxx,zzjc,sxjc,zzl=it.sxbl()
	if chk==0 then return tc and zzx>0 end
	local zz,sx,lv=it.sxblx(tp,kx,zzx,sxx,zzl)
	e:SetLabel(zz,sx,lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if not c:IsRelateToEffect(e) then return end
	local zz,sx,lv=e:GetLabel()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0,TYPE_NORMAL+TYPE_MONSTER+TYPE_TUNER,0,0,lv,zz,sx) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_MONSTER+TYPE_TUNER,sx,zz,lv,0,0)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3,true)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function (e1,c1)
		return Duel.GetMatchingGroupCount(cm.vfilter,tp,LOCATION_GRAVE+QY_cw,0,nil)*500
	end)
	c:RegisterEffect(e2 ,true)
	Duel.SpecialSummonComplete()

	if not tc:IsImmuneToEffect(e) then
		Duel.Equip(tp,tc,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function cm.vfilter(c)
	return aux.IsCodeListed(c, yr) and c:IsType(TYPE_EQUIP)
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end

function cm.cfilter(c,tp,rp)
	return c:IsType(TYPE_EQUIP)
end
function cm.cfilter2(c,tp)
	return c:GetOwner()==tp
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject():GetLabel()
	return ec~=0
end
function cm.filter6(c,e,tp,id,g)
	return c:IsCanBeEffectTarget(e) and #g:Filter(cm.filter4, nil,c,id)~=0
end
function cm.filter5(c,e,tp,tc)
	local o=true
	if tc~=nil then
		o=c:CheckEquipTarget(tc)
	end
	return c:IsType(TYPE_EQUIP) and not c:IsCode(m) and aux.IsCodeListed(c, yr) and o
end
function cm.filter4(c,c2,id)
	return c:CheckEquipTarget(c2) and not c:IsCode(m) and aux.IsCodeListed(c, yr)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(QY_cw) end
	Duel.SendtoGrave(c,REASON_EFFECT+REASON_RETURN)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g2 = Duel.GetMatchingGroup( cm.filter5, tp, QY_kz, 0, nil,e,tp)
	local g1 = Duel.GetMatchingGroup( cm.filter6, tp, QY_gs, QY_gs, nil,e,tp,m,g2)
	-- local g3 = g2:Filter(aux.TRUE, nil)
	if chk==0 then return Duel.GetLocationCount(tp,QY_mx)>0 and #g1>0 end
	local c=e:GetHandler()
	Duel.SelectTarget(tp,Card.IsFaceup,tp,QY_gs,QY_gs,1,1,nil)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g2 = Duel.GetMatchingGroup( cm.filter5, tp, QY_kz, 0, nil,e,tp,tc)
	g2=g2:Select(tp, 1, 1, nil):GetFirst()
	if tc:IsRelateToEffect(e) then
		Duel.Equip(tp,g2,tc)
	end
	Duel.BreakEffect()
	if c:IsLocation(QY_cw) and c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT+REASON_RETURN)
	end
end