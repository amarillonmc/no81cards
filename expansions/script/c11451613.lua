--幽玄龙象※离召升明
--21.07.28
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451416,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_MOVE)
		ge2:SetCondition(cm.regcon)
		ge2:SetOperation(cm.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.cfilter(c)
	local p,loc,seq=c:GetPreviousControler(),c:GetPreviousLocation(),c:GetPreviousSequence()
	if loc==LOCATION_MZONE then if seq==5 then seq=1 elseif seq==6 then seq=3 end end
	return c:IsPreviousLocation(LOCATION_ONFIELD) and seq<5 and Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,p,seq) and (not c:IsOnField() or aux.GetColumn(c,p)~=seq)
end
function cm.actfilter(c,p,seq)
	return aux.GetColumn(c,p)==seq
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c,ec)
	if not c:IsSetCard(0x3978) and c~=ec then return false end
	local eset1={c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC)}
	local eset2={c:IsHasEffect(EFFECT_LIMIT_SET_PROC)}
	local eset3={c:IsHasEffect(EFFECT_SUMMON_PROC)}
	local eset4={c:IsHasEffect(EFFECT_SET_PROC)}
	local e1,e2=Effect.CreateEffect(ec),Effect.CreateEffect(ec)
	local _CheckTribute=Duel.CheckTribute
	local _GetLocationCount=Duel.GetLocationCount
	local _GetMZoneCount=Duel.GetMZoneCount
	function Duel.CheckTribute(c,mi,ma,mg,top,...)
		local g=mg or Duel.GetTributeGroup(c)
		g=g:Filter(function(c) return not c:IsLocation(LOCATION_MZONE) or c:GetOriginalType()&TYPE_LINK==0 end,nil)
		return _CheckTribute(c,mi,ma,g,top,...) and _GetMZoneCount(top)>0
	end
	function Duel.GetLocationCount(p,loc,...)
		if loc~=LOCATION_MZONE then return _GetLocationCount(p,loc,...) end
		return _GetMZoneCount(p,nil,...)
	end
	function Duel.GetMZoneCount(p,lg,...)
		return _GetMZoneCount(p,nil,...)
	end
	local mi,ma=c:GetTributeRequirement()
	if #eset1==0 then
		--summon
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
		e1:SetCondition(cm.ttcon)
		if mi>0 then e1:SetValue(SUMMON_TYPE_ADVANCE) end
		c:RegisterEffect(e1,true)
	end
	if #eset2==0 then
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LIMIT_SET_PROC)
		e2:SetCondition(cm.ttcon)
		c:RegisterEffect(e2,true)
	end
	local res1,res2=c:IsSummonable(true,nil),c:IsMSetable(true,nil)
	e1:Reset()
	e2:Reset()
	if not res1 or not res2 then
		if #eset1==0 and #eset3>0 then
			for _,te in pairs(eset3) do
				res1=res1 or c:IsSummonable(true,te)
				if res1 then break end
			end
		end
		if #eset2==0 and #eset4>0 then
			for _,te in pairs(eset4) do
				res2=res2 or c:IsMSetable(true,te)
				if res2 then break end
			end
		end
	end
	Duel.CheckTribute=_CheckTribute
	Duel.GetLocationCount=_GetLocationCount
	Duel.GetMZoneCount=_GetMZoneCount
	return (res1 or res2),res1,res2
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and (mi==0 or Duel.CheckTribute(c,mi))
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		local _,s1,s2=cm.smfilter(tc,c)
		if tc:IsLocation(LOCATION_HAND) then
			--tribute
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_MATERIAL_CHECK)
			e2:SetValue(cm.valcheck)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SUMMON_COST)
			e3:SetOperation(cm.facechk)
			e3:SetLabelObject(e2)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_MSET_COST)
			tc:RegisterEffect(e4)
		end
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function cm.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local tc=g:GetFirst()
	if e:GetLabel()==1 then
		e:SetLabel(0)
		g:KeepAlive()
		--release replace
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EFFECT_SEND_REPLACE)
		e3:SetLabelObject(g)
		e3:SetTarget(cm.reptg)
		e3:SetValue(function(e,c) return c:GetFlagEffect(m)>0 end)
		Duel.RegisterEffect(e3,c:GetControler())
	end
	e:Reset()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if not g then e:Reset() return false end
	if chk==0 then return #Group.__band(eg,g)>0 end
	for tc in aux.Next(g) do
		Duel.HintSelection(Group.FromCards(tc))
		tc:RegisterFlagEffect(m,RESET_CHAIN,0,1)
		local p=0xd
		if tc:IsStatus(STATUS_BATTLE_DESTROYED) then p=POS_FACEUP end
		local pos=Duel.SelectPosition(tp,tc,p&~tc:GetPosition())
		local prop=e:GetProperty()
		e:SetProperty(prop|EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.ChangePosition(tc,pos)
		e:SetProperty(prop)
	end
	g:DeleteGroup()
	e:SetLabelObject(nil)
	return true
end
function cm.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
	e:Reset()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEDOWN) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.tgfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevelBelow(9) and c:IsCanBeEffectTarget(e)
end
function cm.fselect(g)
	return #g==1 or g:GetSum(Card.GetLevel)==9
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e) end
	local sg=Group.CreateGroup()
	local seq=e:GetHandler():GetPreviousSequence()
	if e:GetHandler():GetPreviousControler()==1-tp then seq=4-seq end
	e:SetLabel(seq)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)>0 then
		local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE,0,nil,e)
		sg=g:SelectSubGroup(tp,cm.fselect,false,1,99)
		Duel.HintSelection(sg)
		Duel.SetTargetCard(sg)
	else
		sg=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e)
	end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function cm.clfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
end