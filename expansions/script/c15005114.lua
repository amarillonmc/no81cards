local m=15005114
local cm=_G["c"..m]
cm.name="断空鹰刃昏暗吸积"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Equip Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(cm.eqlimit)
	c:RegisterEffect(e2)
	--effect indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.efftg)
	e4:SetValue(cm.evalue)
	c:RegisterEffect(e4)
	--pen
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,15005114)
	e5:SetTarget(cm.sctg)
	e5:SetOperation(cm.scop)
	c:RegisterEffect(e5)
end
function cm.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.eqlimit(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function cm.efftg(e,c)
	return c==e:GetHandler():GetEquipTarget()
end
function cm.evalue(e,re,rp)
	return re:IsActiveType(TYPE_TRAP) and rp==1-e:GetHandlerPlayer()
end
function cm.scfilter(c,pc)
	local scl1=c:GetLeftScale()
	local scl2=pc:GetRightScale()
	local dif=math.abs(scl1-scl2)
	return c:IsType(TYPE_PENDULUM) and dif>=2 and c:IsAbleToExtra()
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetEquipTarget()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.scfilter,tp,LOCATION_DECK,0,1,1,nil,c:GetEquipTarget())
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)>0 then
		local sc=tc:GetLeftScale()
		if not aux.PendulumChecklist then
			aux.PendulumChecklist=0
			local ge1=Effect.GlobalEffect()
			ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
			ge1:SetOperation(aux.PendulumReset)
			Duel.RegisterEffect(ge1,0)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(1163)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC_G)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCondition(cm.PendCondition())
		e1:SetOperation(cm.PendOperation())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetLabel(sc)
		e1:SetValue(SUMMON_TYPE_PENDULUM)
		c:RegisterEffect(e1)
	end
end
function cm.PendCondition()
	return  function(e,c,og)
				if c==nil then return true end
				if not e:GetHandler():GetEquipTarget() then return false end
				if not e:GetLabel() then return false end
				local sc1=e:GetLabel()
				local sc2=e:GetHandler():GetEquipTarget():GetLeftScale()
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				local lscale=sc1
				local rscale=sc2
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
			end
end
function cm.PendOperation()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				if not e:GetHandler():GetEquipTarget() then return false end
				if not e:GetLabel() then return false end
				local sc1=e:GetLabel()
				local sc2=e:GetHandler():GetEquipTarget():GetLeftScale()
				local rpz=e:GetHandler()
				local lscale=sc1
				local rscale=sc2
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(aux.PConditionFilter,nil,e,tp,lscale,rscale,eset)
				else
					tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
				end
				local ce=nil
				local b1=aux.PendulumChecklist&(0x1<<tp)==0
				local b2=#eset>0
				if b1 and b2 then
					local options={1163}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					if op>0 then
						ce=eset[op]
					end
				elseif b2 and not b1 then
					local options={}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					ce=eset[op+1]
				end
				if ce then
					tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				aux.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				aux.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:UseCountLimit(tp)
				else
					aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(e:GetHandler()))
			end
end