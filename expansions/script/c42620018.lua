--海晶少女·蓝蓝
local m=42620018
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	--aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),4,10,cm.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.LinkCondition(aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),4,10,cm.lcheck))
	e1:SetTarget(cm.LinkTarget(aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),4,10,cm.lcheck))
	e1:SetOperation(cm.LinkOperation(aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WATER),4,10,cm.lcheck))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.atcost)
	e4:SetTarget(cm.attg)
	e4:SetOperation(cm.atop)
	c:RegisterEffect(e4)
	--disable spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(cm.condition)
	e5:SetTargetRange(1,0)
	e5:SetTarget(cm.splimit)
	c:RegisterEffect(e5)
	--damage reduce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e6:SetCondition(cm.condition)
	e6:SetValue(aux.ChangeBattleDamage(1,HALF_DAMAGE))
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetCondition(cm.condition)
	e7:SetValue(cm.efilter)
	c:RegisterEffect(e7)
	-- --effectgain
	-- local e8=Effect.CreateEffect(c)
	-- e8:SetDescription(aux.Stringid(m,2))
	-- e8:SetCategory(CATEGORY_DESTROY)
	-- e8:SetType(EFFECT_TYPE_IGNITION)
	-- e8:SetRange(LOCATION_SZONE)
	-- e8:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	-- e8:SetCountLimit(1)
	-- e8:SetCost(cm.descost)
	-- e8:SetTarget(cm.destg)
	-- e8:SetOperation(cm.desop)
	-- local e9=Effect.CreateEffect(c)
	-- e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	-- e9:SetRange(LOCATION_MZONE)
	-- e9:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	-- e9:SetCondition(cm.condition)
	-- e9:SetTarget(cm.eftg)
	-- e9:SetLabelObject(e8)
	-- c:RegisterEffect(e9)
	-- local e10=Effect.CreateEffect(c)
	-- e10:SetDescription(aux.Stringid(m,3))
	-- e10:SetCategory(CATEGORY_REMOVE)
	-- e10:SetType(EFFECT_TYPE_IGNITION)
	-- e10:SetRange(LOCATION_SZONE)
	-- e10:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	-- e10:SetCountLimit(1)
	-- e10:SetCost(cm.recost)
	-- e10:SetTarget(cm.retg)
	-- e10:SetOperation(cm.reop)
	-- local e11=Effect.CreateEffect(c)
	-- e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	-- e11:SetRange(LOCATION_MZONE)
	-- e11:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	-- e11:SetCondition(cm.condition)
	-- e11:SetTarget(cm.eftg)
	-- e11:SetLabelObject(e10)
	-- c:RegisterEffect(e11)
	--equip
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_EQUIP)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCountLimit(1,m+1)
	e12:SetCost(aux.bfgcost)
	e12:SetTarget(cm.eqtg)
	e12:SetOperation(cm.eqop)
	c:RegisterEffect(e12)
end

c42620018.SetCard_Blue=true

function cm.lcheckfilter(c)
	return c:IsLinkSetCard(0x12b) or c:IsLinkRace(RACE_SEASERPENT)
end

function cm.lcheck(g)
	return g:IsExists(cm.lcheckfilter,1,nil)
end

function cm.f(c)
	return c:IsLinkAttribute(ATTRIBUTE_WATER)
end

function cm.getlinkcount(c)
	if c:IsType(TYPE_XYZ) and c:IsLinkRace(RACE_SEASERPENT) and c:IsRank(4) then
		return 1+0x10000*4
	elseif c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end

function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return (sg:CheckWithSumEqual(cm.getlinkcount,lc:GetLink(),#sg,#sg))
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(aux.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end

function cm.LinkCondition(f,minc,maxc,gf)
	return
	function(e,c,og,lmat,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local minc=minc
		local maxc=maxc
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		local tp=c:GetControler()
		local mg=nil
		if og then
			mg=og:Filter(aux.LConditionFilter,nil,f,c,e)
		else
			mg=aux.GetLinkMaterials(tp,f,c,e)
		end
		if lmat~=nil then
			if not aux.LConditionFilter(lmat,f,c,e) then return false end
			mg:AddCard(lmat)
		end
		local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
		if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
		Duel.SetSelectedCard(fg)
		return mg:CheckSubGroup(cm.LCheckGoal,minc,maxc,tp,c,gf,lmat)
	end
end

function cm.LinkTarget(f,minc,maxc,gf)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
		local minc=minc
		local maxc=maxc
		if min then
			if min>minc then minc=min end
			if max<maxc then maxc=max end
			if minc>maxc then return false end
		end
		local mg=nil
		if og then
			mg=og:Filter(aux.LConditionFilter,nil,f,c,e)
		else
			mg=aux.GetLinkMaterials(tp,f,c,e)
		end
		if lmat~=nil then
			if not aux.LConditionFilter(lmat,f,c,e) then return false end
			mg:AddCard(lmat)
		end
		local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
		Duel.SetSelectedCard(fg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local cancel=Duel.IsSummonCancelable()
		local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
		if sg then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end

function cm.LinkOperation(f,minc,maxc,gf)
	return
	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Auxiliary.LExtraMaterialCount(g,c,tp)
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
		g:DeleteGroup()
	end
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end

function cm.eqfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and not c:IsForbidden() and c:IsFaceup()
end

function cm.tgtfilter(c)
	return not c:IsType(TYPE_FIELD) and c:IsAbleToGrave()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tgtfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eqfilter,tp,0x34,0x34,1,e:GetHandler()) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,nil,0,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,LOCATION_SZONE)
end

function cm.optfilter(c,g)
	return not g:IsExists(Card.IsCode,1,nil,c:GetCode())
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(cm.tgtfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		local tg=Duel.SendtoGrave(g,REASON_EFFECT)
		if tg then
			local mlink=c:GetMaterial():GetSum(Card.GetLink)+tg
			if mlink>=10 then mlink=10 end
			local gg=Duel.GetMatchingGroup(cm.eqfilter,tp,0x34,0x34,c)
			local locc=Duel.GetLocationCount(tp,LOCATION_SZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)
			local n=math.min(locc,mlink)
			if n>0 and #gg>=n then
				local sg=Group.CreateGroup()
				while #sg<=n do
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
					local ssg=gg:FilterSelect(tp,cm.optfilter,1,1,sg,sg)
					sg:Merge(ssg)
				end
				if sg:GetCount()>0 then
					local sc=sg:GetFirst()
					while sc do
						if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
							Duel.MoveToField(sc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
						end
						Duel.Equip(tp,sc,c,false,true)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e1:SetValue(cm.eqlimit)
						e1:SetLabelObject(c)
						sc:RegisterEffect(e1)
						sc=sg:GetNext()
					end
					Duel.EquipComplete()
				end
			end
		end
	end
end

function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end

function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1800) end
	local pay=Duel.GetLP(tp)/2+900
	Duel.PayLPCost(tp,pay)
	e:SetLabel(pay*2)
end

function cm.tgafilter(c,tc)
	return c:GetEquipTarget()==tc and c:GetBaseAttack()>0
end

function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(cm.tgafilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,c)
		if #g>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(e:GetLabel()+g:GetSum(Card.GetBaseAttack))
			c:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(e:GetLabel())
			c:RegisterEffect(e1)
		end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ATTACK)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(cm.ftarget)
	e0:SetLabel(c:GetFieldID())
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end

function cm.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function cm.eftg(e,c)
	return c:IsType(TYPE_EQUIP)
end

function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end

function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAttribute(ATTRIBUTE_WATER) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAttribute,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler(),ATTRIBUTE_WATER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsAttribute,tp,LOCATION_MZONE,0,1,1,nil,ATTRIBUTE_WATER)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler(),ATTRIBUTE_WATER)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(tc)
			e1:SetValue(cm.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
end