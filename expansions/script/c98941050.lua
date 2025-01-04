--影灵衣之魂
local m=98941050
local cm=_G["c"..m]
cm.name="Ritual"
cm.list={66069967,19516687,90027012,80701178,53180020,67503139,16312943,34358408,66399675,77153811,39905966,52738610,27796375,84388461,23401839,95492061,29888389,56827051,82128978,32013448,50155385,46123974,4141820,90307777,82085295,93506862,47106439,38356857,22420202,33543890,60037599,96026108,97148796,46485778,34334692,30492798,59913418,96915510,78316184,13518809,88926295,39618799,91668401,25726386,63233638,99628747,88106656,47963370,3909436,65877963,12266229,3629090,95825679,52495649,99427357,50139096,86124104,63056220,52707042,15001940,10925955,13048472,64442155,65450690,72386290,96729612,99426088,7986397,8428836,9236985,11398951,13386407,14094090,14166715,14735698,16310544,16494704,17888577,21082832,23459650,28429121,31002402,34767865,36350300,36982581,37626500,38784726,39996157,41085464,44221928,45948430,46052429,46159582,47435107,51124303,52913738,59820352,60234913,60921537,69035382,80566312,85327820,86758915,87778106,94666032,97211663,27331568,57970721,59514116,69003792,95612049,14220547,15590355,25796442,33971095,35569555,84121302,88301833,91946859,93754402,48206762,54351224,55976207,13482262,15306543,15388353,18890039,40089744,69217334,84504242,95658967,90444325,36849933,34072799,89016236,8454126,53618197,78990927,26223582,2266498,9145181,20417688,38844957,42158279,44889144,51510279,53174748,64437633,88083109,14478717,40551410,81306186,84965420,87955518,98904974,29904964,42600274,31772684,6628343,33145233,8903700,67267333,49477180,33245030,20560620,49394035,70491682,51522296,69815951,95209656,48546368,21105106,39468724,88240999,52068432,42932862,55410871,52900000,70551291,20654247,34093683,98287529,25857246,16313112,25415052,45877457,72566043,66425726,61757117,74122412,30646525,37061511,35330871,56350972,11877465,71406430,45222299,4388680,26674724,13482075,52846880,89463537,19489718,60823690,33325951,48654323,45001322,99185129,88176533,8198712,8955148,9786492,18803791,20071842,27383110,30392583,32828635,34834619,41426869,45410988,55761792,58827995,62835876,73055622,78577570,79306385,80811661,94377247,96420087,21862633,44182827,23160024,32354768,22888900,54094821,60375194,76552147,45675980,69120785,4335427,64202399,90583279,72656408,18474999,15397015,35618486,63942761,57617178,31118030,53303460,57357130,20228463,76103404,28053106,41306080,66729231,94997874,54484652,57272170,98941049,71203602,24731391,77235086,30334522,86401517,64631466,65037172,1969506,12470447,41850466,83308376,99162753,83533296,98850929,9553721,48784854,96239878,56787189,58793369,2287848,36809777,46337945,83326048,94423983,14005031,17722185,56863746,22435424,24166324,61773610,10804018,39114494,10774240,25801745,51296484,88284599,52472775,98477480,86310763,100227072,100227073,100227075,92487128,100227074,43219114,87003671,51618973,13408726,50596425}
function c98941050.initial_effect(c)
	--c:EnableReviveLimit()
	aux.AddCodeList(c,98941050)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c98941050.splimit)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98941050,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c98941050.spcon1)
	e2:SetTarget(c98941050.sptg)
	e2:SetOperation(c98941050.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c98941050.spcon2)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c98941050.thtg)
	e4:SetOperation(c98941050.thop)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetCountLimit(1,98941050)
	e5:SetCondition(c98941050.atkcon)
	e5:SetTarget(c98941050.atktg)
	e5:SetOperation(c98941050.atkop)
	c:RegisterEffect(e5)
end
function c98941050.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xb4)
end
function c98941050.hspfilter(c,tp)
	return c:IsReleasable() and c:IsControler(tp)
end
function c98941050.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c98941050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if c==nil then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	local tp=c:GetControler()
	local ct=0
	if Duel.CheckReleaseGroup(tp,c98941050.hspfilter,1,nil,tp) then ct=ct-1 end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>ct
		and (Duel.CheckReleaseGroupEx(tp,Card.IsReleasable,1,e:GetHandler()) or Duel.GetTurnPlayer()==tp)
end
function c98941050.rrfilter(c,e,tp)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c98941050.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if Duel.GetTurnPlayer()==tp and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(98941050,2)) then
	   Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	   c:CompleteProcedure()
	else
	   local sg=Duel.SelectMatchingCard(tp,c98941050.rrfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   tc=sg:GetFirst()
	   if not tc then return false end
	   if ft>0 then
		  g=Duel.SelectReleaseGroupEx(tp,Card.IsReleasableByEffect,1,1,REASON_EFFECT,true,tc)
	   else
		  g=Duel.SelectReleaseGroupEx(tp,c98941050.hspfilter,1,1,REASON_EFFECT,false,nil,tp)
	   end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   c:SetMaterial(g)
	   Duel.ReleaseRitualMaterial(g)
	   Duel.BreakEffect()
	   Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
	   tc:CompleteProcedure()
   end
end
function c98941050.spfilter(c,tp,re)
	return c:IsControler(tp) and c:IsType(TYPE_RITUAL) and not re:GetHandler():IsCode(98941050) and c:IsFaceup()
end
function c98941050.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98941050.spfilter,1,nil,tp,re)
end
function c98941050.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xaf) and c:IsAbleToHand()
end
function c98941050.filter2(c)
	return c:IsCode(table.unpack(cm.list)) and c:IsAbleToHand()
end
function c98941050.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local b1=(#g>0) and Duel.GetFlagEffect(tp,98941050)==0
	local b2=Duel.IsExistingMatchingCard(c98941050.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,98942050)==0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(98941050,0),aux.Stringid(98941050,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(98941050,0))
	else op=Duel.SelectOption(tp,aux.Stringid(98941050,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
		Duel.RegisterFlagEffect(tp,98941050,RESET_CHAIN,0,1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,98942050,RESET_CHAIN,0,1)
	end
end
function c98941050.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
		   Duel.HintSelection(g)
		   Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c98941050.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			local code=sg:GetFirst():GetCode()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_HAND)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(c98941050.thlimit)
			e0:SetLabel(code)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function c98941050.thlimit(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(98941050)
end
function c98941050.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c98941050.atklimitcon(e)
	return e:GetLabel()~=0
end
function c98941050.atklimittg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c98941050.checkop(e,tp,eg,ep,ev,re,r,rp)
	local fid=eg:GetFirst():GetFieldID()
	e:GetLabelObject():SetLabel(fid)
end
function c98941050.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c98941050.fcfilter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c98941050.ffilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToHand()
end
function c98941050.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941050.fcfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c98941050.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	local dg=Duel.GetMatchingGroup(c98941050.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=math.min(3,dg:GetCount())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c98941050.fcfilter,tp,LOCATION_MZONE,0,1,ct,nil)
	if Duel.Remove(rg,0,REASON_COST+REASON_TEMPORARY)~=0 then
			rg:KeepAlive()
			for tc in aux.Next(rg) do
				tc:RegisterFlagEffect(98941050,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(rg)
			e1:SetCountLimit(1)
			e1:SetOperation(c98941050.retop)
			Duel.RegisterEffect(e1,tp)
		end
	local rc=rg:GetCount()
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,rc,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98941050.retfilter(c,tp)
	return c:GetFlagEffect(98941050)~=0 and (not tp or c:IsControler(tp))
end
function c98941050.returngroup(g,tp)
	if #g==0 then return end
	local c
	while #g>1 and Duel.GetMZoneCount(tp)>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		c=g:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(c)
		g=g-c
	end
	for oc in aux.Next(g) do
		Duel.ReturnToField(oc)
	end
end
function c98941050.retop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g1=e:GetLabelObject():Filter(c98941050.retfilter,nil,turnp)
	local g2=e:GetLabelObject():Filter(c98941050.retfilter,nil,1-turnp)
	if #g1+#g2==0 then return end
	c98941050.returngroup(g1,turnp)
	c98941050.returngroup(g2,1-turnp)
end
function c98941050.gcheck(g)
	return g:FilterCount(Card.IsSetCard,nil,0x2b)<2 and g:FilterCount(Card.IsSetCard,nil,0x61)<2
		and g:GetClassCount(Card.GetLocation)==#g
end
function c98941050.atkop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c98941050.ffilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=e:GetLabel()
	if dg:GetClassCount(Card.GetCode)<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=dg:SelectSubGroup(tp,c98941050.gcheck,false,1,ct)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
