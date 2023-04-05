local m=53796107
local cm=_G["c"..m]
cm.name="侵入魔鬼指令"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.adjustop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SUMMON_SUCCESS)
		ge3:SetOperation(cm.sumcount)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge3:Clone()
		Duel.RegisterEffect(ge6,1)
		local ge7=ge4:Clone()
		Duel.RegisterEffect(ge7,1)
		local ge8=ge5:Clone()
		Duel.RegisterEffect(ge8,1)
		local ge11=Effect.CreateEffect(c)
		ge11:SetDescription(aux.Stringid(m,0))
		ge11:SetType(EFFECT_TYPE_FIELD)
		ge11:SetCode(EFFECT_SUMMON_COST)
		ge11:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		ge11:SetTarget(function(e,c,tp)
			e:SetLabelObject(c)
			return true
		end)
		ge11:SetOperation(cm.sumcop)
		Duel.RegisterEffect(ge11,0)
		local ge12=ge11:Clone()
		ge12:SetCode(EFFECT_MSET_COST)
		Duel.RegisterEffect(ge12,0)
		local ge13=ge11:Clone()
		Duel.RegisterEffect(ge13,1)
		local ge14=ge12:Clone()
		Duel.RegisterEffect(ge14,1)
		local ge15=Effect.CreateEffect(c)
		ge15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge15:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge15:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+m)
		ge15:SetOperation(cm.start)
		Duel.RegisterEffect(ge15,0)
		cm[0]=Duel.IsPlayerAffectedByEffect
		Duel.IsPlayerAffectedByEffect=function(p,code)
			local t={}
			local le={cm[0](p,code)}
			for _,v in pairs(le) do if v:GetLabel()~=m then table.insert(t,v) end end
			return table.unpack(t)
		end
		cm[1]=Duel.GetActivityCount
		Duel.GetActivityCount=function(p,actp,...)
			local ct=cm[1](p,actp,...)
			if actp==ACTIVITY_NORMALSUMMON then ct=ct-Duel.GetFlagEffect(p,m+500) end
			return math.max(ct,0)
		end
		cm[2]=Card.IsSummonable
		Card.IsSummonable=function(sc,bool,...)
			local res=cm[2](sc,bool,...)
			if bool==true then
				cm.effect_sumcheck=true
				res=cm[2](sc,bool,...)
				cm.effect_sumcheck=false
			end
			return res
		end
		cm[3]=Card.IsMSetable
		Card.IsMSetable=function(sc,bool,...)
			local res=cm[3](sc,bool,...)
			if bool==true then
				cm.effect_sumcheck=true
				res=cm[3](sc,bool,...)
				cm.effect_sumcheck=false
			end
			return res
		end
		cm[4]=Duel.Summon
		Duel.Summon=function(p,sc,bool,...)
			if bool==true then cm.effect_sumcheck=true end
			return cm[4](p,sc,bool,...)
		end
		cm[5]=Duel.MSet
		Duel.MSet=function(p,sc,bool,...)
			if bool==true then cm.effect_sumcheck=true end
			return cm[5](p,sc,bool,...)
		end
		cm[6]=function(p,actp,...)
			local ct=Duel.GetActivityCount(p,actp,...)
			ct=ct-Duel.GetFlagEffect(p,m+2000)
			return math.max(ct,0)
		end
	end
end
function cm.start(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,0xff,0xff,nil,58494728,94092230)
	cm[7]=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,f)
		local cd=e:GetCode()
		if cd==EFFECT_SUMMON_PROC then
			e:SetCondition(cm.otcon1)
			e:SetOperation(cm.otop1)
		elseif cd==EFFECT_LIMIT_SUMMON_PROC then
			e:SetCondition(cm.otcon2)
			e:SetOperation(cm.otop2)
		end
		return cm[7](tc,e,f)
	end
	for tc in aux.Next(g1) do
		if tc.initial_effect then
			local ini=cm.initial_effect
			cm.initial_effect=function() end
			tc:ReplaceEffect(m,0)
			cm.initial_effect=ini
			tc.initial_effect(tc)
		end
	end
	Card.RegisterEffect=cm[7]
	local g2=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,0xff,0xff,nil,22009013,62007535,84488827,85505315)
	for tc in aux.Next(g2) do
		local ex1=Effect.CreateEffect(tc)
		ex1:SetDescription(aux.Stringid(m,0))
		ex1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ex1:SetType(EFFECT_TYPE_SINGLE)
		ex1:SetCode(EFFECT_SUMMON_PROC)
		ex1:SetCondition(cm.sumcon)
		ex1:SetOperation(cm.sumop)
		ex1:SetValue(SUMMON_TYPE_ADVANCE)
		tc:RegisterEffect(ex1,true)
		local ex2=ex1:Clone()
		ex2:SetCode(EFFECT_SET_PROC)
		tc:RegisterEffect(ex2,true)
	end
	local g3=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,0,0xff,0xff,nil,58494728)
	for tc in aux.Next(g3) do
		local ex3=Effect.CreateEffect(tc)
		ex3:SetDescription(aux.Stringid(m,0))
		ex3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		ex3:SetType(EFFECT_TYPE_SINGLE)
		ex3:SetCode(EFFECT_SET_PROC)
		ex3:SetCondition(cm.sumcon)
		ex3:SetOperation(cm.sumop)
		ex3:SetValue(SUMMON_TYPE_ADVANCE)
		tc:RegisterEffect(ex3,true)
	end
end
function cm.thfilter1(c,tp)
	return c:IsSetCard(0xa) and c:IsLevelAbove(5) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,c)
end
function cm.thfilter2(c)
	return c:IsSetCard(0x65) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g1:GetCount()~=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,g1:GetFirst())
	if g2:GetCount()~=1 then return end
	local code1,code2=g1:GetFirst():GetCode(),g2:GetFirst():GetCode()
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(cm.thlimit)
	e0:SetLabel(code1,code2)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
end
function cm.thlimit(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(m)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x65)
end
function cm.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x100a) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.sumfilter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g==0 then return end
	local c=e:GetHandler()
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	local le={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SET_SUMMON_COUNT_LIMIT)}
	for _,v in ipairs(le) do ct=math.max(ct,v:GetValue()) end
	local ce={Duel.IsPlayerAffectedByEffect(tp,m)}
	for _,v in ipairs(ce) do
		v:GetLabelObject():GetLabelObject():GetLabelObject():GetLabelObject():Clear()
		v:GetLabelObject():GetLabelObject():GetLabelObject():Reset()
		v:GetLabelObject():GetLabelObject():Reset()
		v:GetLabelObject():Reset()
		v:Reset()
	end
	if not Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_DECK,0,1,nil,m) then return end
	local g=Duel.GetMatchingGroup(function(c)return (c:IsHasEffect(EFFECT_EXTRA_SUMMON_COUNT) or c:IsHasEffect(EFFECT_EXTRA_SET_COUNT)) and (cm[2](c,true,nil) or cm[3](c,true,nil))end,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if #g>0 then Duel.RegisterFlagEffect(tp,m+1000,RESET_PHASE+PHASE_END,0,1) end
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(m)
	e1:SetLabelObject(g)
	e1:SetTargetRange(1,0)
	e1:SetValue(ct+1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetLabel(ct)
	e2:SetLabelObject(e1)
	e2:SetTarget(cm.splimit1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetTarget(cm.splimit2)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(m)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetLabelObject(e3)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.splimit1(e,c,tp,sumtp)
	if cm.effect_sumcheck then return false end
	local lb=0
	local g=e:GetLabelObject()
	while aux.GetValueType(g)~="Group" do g=g:GetLabelObject() end
	local b1=g:IsContains(c) and Duel.GetFlagEffect(tp,m+1500)==0
	if Duel.GetFlagEffect(tp,m+1000)>0 and b1 then lb=1 end
	if cm[6](tp,ACTIVITY_NORMALSUMMON)-lb<e:GetLabel() then return false end
	local res=false
	if c:GetTributeRequirement()>0 then res=true end
	local b2=c:IsSetCard(0x100a) and res
	return not (b1 or b2)
end
function cm.splimit2(e,c,tp,sumtp)
	if cm.effect_sumcheck then return false end
	local lb=0
	local g=e:GetLabelObject()
	while aux.GetValueType(g)~="Group" do g=g:GetLabelObject() end
	local b1=g:IsContains(c) and Duel.GetFlagEffect(tp,m+1500)==0
	if Duel.GetFlagEffect(tp,m+1000)>0 and b1 then lb=1 end
	if cm[6](tp,ACTIVITY_NORMALSUMMON)-lb<e:GetLabel() then return false end
	local res=false
	if c:GetTributeRequirement()>0 then res=true end
	local b2=c:IsSetCard(0x100a) and res
	return not (b1 or b2)
end
function cm.sumcount(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	if cm.effect_sumcheck then
		Duel.RegisterFlagEffect(tp,m+2000,RESET_PHASE+PHASE_END,0,1)
		cm.effect_sumcheck=false
		return
	end
	local tc=eg:GetFirst()
	local res=tc:IsSummonType(SUMMON_TYPE_ADVANCE) and tc:IsSetCard(0x100a)
	if res and Duel.GetFlagEffect(tp,m+500)==0 then Duel.RegisterFlagEffect(tp,m+500,RESET_PHASE+PHASE_END,0,1) end
	if tc:GetFlagEffect(m)>0 and not res then
		Duel.RegisterFlagEffect(tp,m+1500,RESET_PHASE+PHASE_END,0,1)
	end
	tc:ResetFlagEffect(m)
end
function cm.sumcop(e,tp,eg,ep,ev,re,r,rp)
	if cm.effect_sumcheck then return end
	local c=e:GetLabelObject()
	if c:IsHasEffect(EFFECT_EXTRA_SUMMON_COUNT) or c:IsHasEffect(EFFECT_EXTRA_SET_COUNT) then
		c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.IsSumReleasable(c,sc)
	local res=true
	local le1={c:IsHasEffect(EFFECT_UNRELEASABLE_SUM)}
	for _,v in pairs(le1) do
		local val=v:GetValue()
		if not val or val(v,c) then res=false end
	end
	local le2={Duel.IsPlayerAffectedByEffect(sc:GetControler(),EFFECT_CANNOT_RELEASE)}
	for _,v in pairs(le2) do
		local val=v:GetValue()
		if not val or val(v,c) then res=false end
	end
	local le3={sc:IsHasEffect(EFFECT_TRIBUTE_LIMIT)}
	for _,v in pairs(le3) do
		local val=v:GetValue()
		if not val or val(v,c) then res=false end
	end
	return res
end
function cm.fselect(g,c,tp)
	local res=true
	for tc in aux.Next(g) do if not cm.IsSumReleasable(tc,c) then res=false end end
	return res and Duel.GetMZoneCount(tp,g)>0
end
function cm.sumcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_DECK,0,1,nil,m) or Duel.GetFlagEffect(tp,m+2500)>0 then return end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	local g=Group.__add(Duel.GetTributeGroup(c),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,m))
	return ma>0 and g:CheckSubGroup(cm.fselect,mi,ma,c,tp)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc)
	local mi,ma=c:GetTributeRequirement()
	if minc and mi<minc then mi=minc end
	local g=Group.__add(Duel.GetTributeGroup(c),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,m))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,cm.fselect,true,mi,ma,c,tp)
	c:SetMaterial(sg)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.RegisterFlagEffect(tp,m+2500,RESET_PHASE+PHASE_END,0,1) end
	Duel.SendtoGrave(sg,REASON_RELEASE+REASON_SUMMON+REASON_MATERIAL)
end
function cm.otfilter(c,tp)
	return c:IsSetCard(0x100a) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.otcon1(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_DECK,0,1,nil,m) and Duel.GetFlagEffect(tp,m+2500)==0 then
		local mi,ma=c:GetTributeRequirement()
		mi=1
		if mi<minc then mi=minc end
		if ma<mi then return false end
		local g=Group.__add(Duel.GetTributeGroup(c),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,m))
		return ma>0 and g:CheckSubGroup(cm.fselect,mi,ma,c,tp)
	else
		local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
	end
end
function cm.otop1(e,tp,eg,ep,ev,re,r,rp,c,minc)
	if Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_DECK,0,1,nil,m) and Duel.GetFlagEffect(tp,m+2500)==0 then
		local mi,ma=c:GetTributeRequirement()
		mi=1
		if minc and mi<minc then mi=minc end
		local g=Group.__add(Duel.GetTributeGroup(c),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,m))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:SelectSubGroup(tp,cm.fselect,true,mi,ma,c,tp)
		c:SetMaterial(sg)
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.RegisterFlagEffect(tp,m+2500,RESET_PHASE+PHASE_END,0,1) end
		Duel.SendtoGrave(sg,REASON_RELEASE+REASON_SUMMON+REASON_MATERIAL)
	else
		local mg=Duel.GetMatchingGroup(cm.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		local sg=Duel.SelectTribute(tp,c,1,1,mg)
		c:SetMaterial(sg)
		Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
	end
end
function cm.otcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_DECK,0,1,nil,m) and Duel.GetFlagEffect(tp,m+2500)==0 then
		local g=Group.__add(Duel.GetTributeGroup(c),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,m))
		return minc<=3 and g:CheckSubGroup(cm.fselect,3,3,c,tp)
	else
		return minc<=3 and Duel.CheckTribute(c,3)
	end
end
function cm.otop2(e,tp,eg,ep,ev,re,r,rp,c,minc)
	if Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_DECK,0,1,nil,m) and Duel.GetFlagEffect(tp,m+2500)==0 then
		local g=Group.__add(Duel.GetTributeGroup(c),Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,m))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:SelectSubGroup(tp,cm.fselect,true,3,3,c,tp)
		c:SetMaterial(sg)
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.RegisterFlagEffect(tp,m+2500,RESET_PHASE+PHASE_END,0,1) end
		Duel.SendtoGrave(sg,REASON_RELEASE+REASON_SUMMON+REASON_MATERIAL)
	else
		local g=Duel.SelectTribute(tp,c,3,3)
		c:SetMaterial(g)
		Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	end
end
